package com.example.textileMultiModalAgent.service.ai;

import com.example.textileMultiModalAgent.common.core.AiJson;
import com.example.textileMultiModalAgent.common.utils.SecurityUtils;
import com.example.textileMultiModalAgent.domain.RagDocument;
import com.example.textileMultiModalAgent.service.file.FileStorageService;
import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.document.splitter.DocumentByParagraphSplitter;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * 知识库管理服务：文档落 MinIO + 向量化写入共享 {@link EmbeddingStore}，并支持启停/删除/重索引。
 *
 * <p>向量化流程：MinIO 取回字节 → 解析文本（txt/md UTF-8；pdf 走 PDFBox，复用 {@link DocumentParseService}）
 * → DocumentByParagraphSplitter(1000,200) 切片 → embeddingModel.embedAll → embeddingStore.addAll；
 * 切片 id 列表以 JSON 存入 chunk_ids，供停用/删除时精确 removeAll。</p>
 *
 * <p>InMemoryEmbeddingStore 进程重启即空，故启动时遍历 enabled=1 的文档重建向量（既定取舍，pgvector 作后续）。</p>
 */
@Slf4j
@Service
public class KnowledgeBaseService {

    /** MinIO 目录前缀 */
    private static final String KB_PREFIX = "kb";

    /** 支持的文档类型 */
    private static final List<String> ALLOWED_EXT = List.of(".md", ".txt", ".pdf", ".doc", ".docx");

    /** 单文件大小上限 20MB */
    private static final long MAX_SIZE = 20L * 1024 * 1024;

    /** 段落切片：每段最多 1000 字符，重叠 200 字符 */
    private final DocumentByParagraphSplitter splitter = new DocumentByParagraphSplitter(1000, 200);

    @Resource
    private RagDocumentService ragDocumentService;

    @Resource
    private FileStorageService fileStorageService;

    @Resource
    private DocumentParseService documentParseService;

    @Resource
    @Qualifier("dynamicEmbeddingModel")
    private EmbeddingModel embeddingModel;

    @Resource
    private EmbeddingStore<TextSegment> embeddingStore;

    /**
     * 上传知识库文档：落 MinIO + 建行 + 向量化。
     *
     * @param file   文档（md/txt/pdf）
     * @param kbType 分类：process/business/competitor
     * @return 落库后的文档行（含向量化状态）
     */
    public RagDocument upload(MultipartFile file, String kbType) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("上传文件为空");
        }
        if (file.getSize() > MAX_SIZE) {
            throw new IllegalArgumentException("文件超过 20MB，请拆分后重试");
        }
        String docName = file.getOriginalFilename();
        String lower = docName.toLowerCase(Locale.ROOT);
        if (ALLOWED_EXT.stream().noneMatch(lower::endsWith)) {
            throw new IllegalArgumentException("仅支持 .md / .doc / .docx / .txt / .pdf 文档");
        }

        String objectKey;
        try {
            objectKey = fileStorageService.upload(file, KB_PREFIX);
        } catch (Exception e) {
            log.warn("知识库文档上传 MinIO 失败，file={}", docName, e);
            throw new IllegalArgumentException("文件上传失败：" + e.getMessage());
        }

        Date now = new Date();
        RagDocument doc = new RagDocument();
        doc.setDoc_name(docName);
        doc.setOss_object_key(objectKey);
        doc.setKb_type(kbType == null || kbType.isBlank() ? "business" : kbType);
        doc.setStatus(0);
        doc.setEnabled(1);
        doc.setDeleted(0);
        doc.setCreate_by(currentUserId());
        doc.setCreate_time(now);
        doc.setUpdate_time(now);
        try {
            doc.setOss_url(fileStorageService.getPreviewUrl(objectKey));
        } catch (Exception e) {
            log.warn("生成知识库预览链接失败，objectKey={}", objectKey, e);
        }
        ragDocumentService.save(doc);

        vectorize(doc);
        return doc;
    }

    /**
     * 启用/停用：停用即从向量库移除切片；启用先移除旧切片再重新向量化（幂等）。
     *
     * @param id      文档id
     * @param enabled true 启用 / false 停用
     */
    public void setEnabled(Long id, boolean enabled) {
        RagDocument doc = requireDoc(id);
        if (!enabled) {
            removeVectors(doc);
            doc.setEnabled(0);
            doc.setUpdate_time(new Date());
            ragDocumentService.updateById(doc);
            return;
        }
        doc.setEnabled(1);
        doc.setUpdate_time(new Date());
        ragDocumentService.updateById(doc);
        vectorize(doc);
    }

    /**
     * 删除：移除向量 + 删除 MinIO 对象 + 逻辑删除行。
     */
    public void delete(Long id) {
        RagDocument doc = requireDoc(id);
        removeVectors(doc);
        if (doc.getOss_object_key() != null) {
            try {
                fileStorageService.deleteFile(doc.getOss_object_key());
            } catch (Exception e) {
                log.warn("删除 MinIO 对象失败，objectKey={}", doc.getOss_object_key(), e);
            }
        }
        doc.setDeleted(1);
        doc.setEnabled(0);
        doc.setUpdate_time(new Date());
        ragDocumentService.updateById(doc);
    }

    /**
     * 重索引：强制重走向量化（先清理旧切片）。
     */
    public void reindex(Long id) {
        RagDocument doc = requireDoc(id);
        vectorize(doc);
    }

    /**
     * 文档列表（未逻辑删除），按 id 倒序。
     */
    public List<RagDocument> list() {
        return ragDocumentService.lambdaQuery()
                .eq(RagDocument::getDeleted, 0)
                .orderByDesc(RagDocument::getId)
                .list();
    }

    /**
     * 启动初始化：InMemoryEmbeddingStore 重启即空，遍历 enabled=1 的文档重建向量。
     */
    @PostConstruct
    public void reloadOnStartup() {
        try {
            List<RagDocument> docs = ragDocumentService.lambdaQuery()
                    .eq(RagDocument::getDeleted, 0)
                    .eq(RagDocument::getEnabled, 1)
                    .list();
            if (docs.isEmpty()) {
                return;
            }
            log.info("知识库启动重建向量，待处理文档数={}", docs.size());
            for (RagDocument doc : docs) {
                try {
                    vectorize(doc);
                } catch (Exception e) {
                    log.warn("启动重建向量失败，docId={}, name={}", doc.getId(), doc.getDoc_name(), e);
                }
            }
        } catch (Exception e) {
            // 建表前/表缺失时不阻断应用启动
            log.warn("知识库启动初始化跳过：{}", e.getMessage());
        }
    }

    /* ---------------- 向量化 ---------------- */

    /** 从 MinIO 取回字节 → 解析 → 切片 → 向量化写入；成功 status=1 存 chunk_ids，失败 status=2 */
    private void vectorize(RagDocument doc) {
        // 幂等：写入前先清理该文档旧切片
        removeVectors(doc);
        try {
            byte[] bytes = readBytes(doc.getOss_object_key());
            String text = documentParseService.parse(doc.getDoc_name(), bytes);
            if (text == null || text.isBlank()) {
                throw new IllegalArgumentException("文档未解析到有效文本");
            }
            Document document = Document.from(text, Metadata.from("file_name", doc.getDoc_name()));
            List<TextSegment> segments = splitter.split(document);
            if (segments.isEmpty()) {
                throw new IllegalArgumentException("文档切片为空");
            }
            List<Embedding> embeddings = embeddingModel.embedAll(segments).content();
            List<String> ids = embeddingStore.addAll(embeddings, segments);

            doc.setChunk_ids(AiJson.mapper().writeValueAsString(ids));
            doc.setStatus(1);
        } catch (Exception e) {
            log.warn("知识库文档向量化失败，docId={}, name={}: {}", doc.getId(), doc.getDoc_name(), e.getMessage());
            doc.setChunk_ids(null);
            doc.setStatus(2);
        }
        doc.setUpdate_time(new Date());
        ragDocumentService.updateById(doc);
    }

    /** 从向量库移除该文档已存切片（按 chunk_ids） */
    private void removeVectors(RagDocument doc) {
        List<String> ids = parseChunkIds(doc.getChunk_ids());
        if (ids.isEmpty()) {
            return;
        }
        try {
            embeddingStore.removeAll(ids);
        } catch (Exception e) {
            log.warn("清理向量切片失败，docId={}: {}", doc.getId(), e.getMessage());
        }
    }

    private byte[] readBytes(String objectKey) throws Exception {
        if (objectKey == null || objectKey.isBlank()) {
            throw new IllegalArgumentException("文档缺少 MinIO objectKey");
        }
        try (InputStream in = fileStorageService.getFileStream(objectKey)) {
            return in.readAllBytes();
        }
    }

    private List<String> parseChunkIds(String json) {
        if (json == null || json.isBlank()) {
            return List.of();
        }
        try {
            return AiJson.mapper().readValue(json,
                    AiJson.mapper().getTypeFactory().constructCollectionType(ArrayList.class, String.class));
        } catch (Exception e) {
            log.warn("chunk_ids 解析失败，忽略清理：{}", e.getMessage());
            return List.of();
        }
    }

    private RagDocument requireDoc(Long id) {
        RagDocument doc = id == null ? null : ragDocumentService.getById(id);
        if (doc == null || Integer.valueOf(1).equals(doc.getDeleted())) {
            throw new IllegalArgumentException("知识库文档不存在");
        }
        return doc;
    }

    /** 当前登录用户id；/knowledge 在 JWT 拦截范围内，兜底 catch 防止上下文缺失时中断上传 */
    private Long currentUserId() {
        try {
            return SecurityUtils.getUserId();
        } catch (Exception e) {
            return null;
        }
    }
}
