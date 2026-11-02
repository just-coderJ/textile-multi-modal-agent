package com.example.textileMultiModalAgent.service.ai;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

import com.example.textileMultiModalAgent.common.utils.LangChain4JPOIUtils;
import dev.langchain4j.data.document.Document;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * 条款文档解析服务：支持 txt / md / pdf 三种类型。
 *
 * <p>txt/md 按 UTF-8 直读；pdf 用 PDFBox 抽取文本层（扫描件无文本层会提示改用粘贴方式）。
 * 解析失败统一抛 {@link IllegalArgumentException}，由控制器转成业务错误提示。</p>
 */
@Slf4j
@Service
public class DocumentParseService {

    /** 与前端 ComplianceView 的 MAX_FILE_SIZE 保持一致 */
    private static final long MAX_SIZE = 5L * 1024 * 1024;

    /**
     * 解析上传文档为纯文本。
     *
     * @param file 条款文档（.txt / .md / .pdf）
     * @return 文档文本
     * @throws IllegalArgumentException 类型不支持 / 超大小 / 解析失败
     */
    public String parse(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("上传文件为空");
        }
        if (file.getSize() > MAX_SIZE) {
            throw new IllegalArgumentException("文件超过 5MB，请拆分条款后重试");
        }
        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        try {
            return parse(name, file.getBytes());
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.warn("条款文档读取失败，file={}", name, e);
            throw new IllegalArgumentException("文件读取失败：" + e.getMessage());
        }
    }

    /**
     * 按文件名后缀解析字节为纯文本（供知识库从 MinIO 取回字节后解析复用）。
     *
     * @param fileName 文件名（决定 txt/md/pdf 解析分支，大小写不敏感）
     * @param bytes    文件字节
     * @return 文档文本
     * @throws IllegalArgumentException 类型不支持 / 解析失败
     */
    public String parse(String fileName, byte[] bytes) throws Exception {
        String name = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);
        if (bytes == null || bytes.length == 0) {
            throw new IllegalArgumentException("文件内容为空");
        }
        if (name.endsWith(".pdf")) {
            return parsePdf(bytes);
        }
        if (name.endsWith(".txt") || name.endsWith(".md")) {
            return new String(bytes, StandardCharsets.UTF_8);
        }
        if (name.endsWith(".doc") || name.endsWith(".docx")) {
            InputStream inputStream = new ByteArrayInputStream(bytes);
            Document document = LangChain4JPOIUtils.parseWord(inputStream, name);
            return document.text();
        }
        throw new IllegalArgumentException("仅支持 .txt / .doc / .docx / .md / .pdf 文件");
    }

    /** PDF 文本层抽取；扫描件无文本层时给出明确指引 */
    private String parsePdf(byte[] bytes) {
        try (PDDocument document = Loader.loadPDF(bytes)) {
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            if (text == null || text.isBlank()) {
                throw new IllegalArgumentException("PDF 未抽取到文本（可能为扫描件），请改用 txt/md 或直接粘贴条款文本");
            }
            return text;
        } catch (IllegalArgumentException e) {
            throw e;
        } catch (Exception e) {
            log.warn("PDF 解析失败", e);
            throw new IllegalArgumentException("PDF 解析失败：" + e.getMessage());
        }
    }
}
