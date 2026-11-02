package com.example.textileMultiModalAgent.ai.app;

import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversation;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationOutput;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationParam;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationResult;
import com.alibaba.dashscope.common.MultiModalMessage;
import com.alibaba.dashscope.common.Role;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

/**
 * 多模态流式问答的 DashScope 官方 SDK 实现（对应百炼「图像与视频理解」Java 示例）。
 *
 * <p>langchain4j 1.x 只有 {@code UserMessage + ImageContent} 的低阶支持，缺少多模态
 * 流式的声明式高阶 API，因此这里直接封装官方 SDK：拼装多模态 content（N 张图 + 1 段文字）
 * → {@code MultiModalConversation.streamCall} 增量流式调用 → RxJava Flowable 桥接为
 * {@link Flux} 逐增量文本下发。</p>
 *
 * <p>本类只做模型 I/O；落库、护栏、SSE 封帧等编排逻辑在控制器/应用层，
 * 便于未来以新 impl 接入其他模型（策略切换见接口注释）。</p>
 */
@Service
@Slf4j
public class AiCodeHelperHigherFactory implements AiCodeHelperHigherService {

    /** 仅发图片无文字时的默认引导语 */
    private static final String DEFAULT_IMAGE_PROMPT =
            "请仔细观察我上传的图片，结合纺织专业知识进行识别、分析并给出解释。";

    /** 文本类附件（txt/md）并入提问时的单文件字符上限，防上下文爆炸 */
    private static final int TEXT_FILE_MAX_CHARS = 20000;

    /** 视觉模型名，与面料识别共用同一配置项 */
    @Value("${langChain4j.community.dashscope.multi-model.model-name}")
    private String visionModelName;

    /** PDF 理解模型名：百炼「PDF理解」仅 qwen3.8 系列支持，含 PDF 的轮次自动切换 */
    @Value("${langChain4j.community.dashscope.multi-model.pdf-model-name:qwen3.8-flash}")
    private String pdfModelName;

    /** 视觉模型 apiKey，缺省复用文本模型的 key（嵌套占位符取默认值） */
    @Value("${langChain4j.community.dashscope.multi-model.api-key}")
    private String apiKey;

    /** 调用统计（百炼用量落 ai_business_log，供后台 Dashboard 聚合与按用户限额） */
    @Resource
    private CallStatisticsService callStatisticsService;

    @Resource
    private ActiveModelService activeModelService;

    @Override
    @Tag(name = "multiModelChat", description = "多模态回复")
    public Flux<String> multiModelChat(List<String> imageUrls, List<MultipartFile> files, String prompt,
                                       Long sessionId, Long userId) {
        List<String> images = imageUrls == null ? List.of() : imageUrls;
        List<MultipartFile> docs = files == null ? List.of() : files;
        if (images.isEmpty() && docs.isEmpty()) {
            return Flux.error(new IllegalArgumentException("multiModelChat 至少需要一张图片或一个文档"));
        }

        // content 顺序即模型阅读顺序：先 N 张图 → 文档 → 最后一段文字提问
        List<Map<String, Object>> contents = new ArrayList<>();
        for (String imageUrl : images) {
            Map<String, Object> imageContent = new HashMap<>();
            imageContent.put("image", imageUrl);
            contents.add(imageContent);
        }
        boolean hasPdf = false;
        StringBuilder textFiles = new StringBuilder();
        for (MultipartFile file : docs) {
            String name = file.getOriginalFilename() == null ? "未命名" : file.getOriginalFilename();
            if (isPdf(name, file.getContentType())) {
                // DashScope「PDF理解」：base64 走 file_data 键，filename 必填；
                // 不能放 MultipartFile 对象，也不能用 file 键（那是 OpenAI 兼容协议的 type）
                try {
                    String base64 = Base64.getEncoder().encodeToString(file.getBytes());
                    Map<String, Object> pdfContent = new HashMap<>();
                    pdfContent.put("file_data", "data:application/pdf;base64," + base64);
                    pdfContent.put("filename", name);
                    contents.add(pdfContent);
                    hasPdf = true;
                } catch (Exception e) {
                    log.error("PDF 读取失败，跳过该附件，fileName={}", name, e);
                }
            } else if (isTextDoc(name)) {
                // txt/md 直接解析为文本并入提问（任何模型都吃得下）
                try {
                    String text = new String(file.getBytes(), StandardCharsets.UTF_8);
                    if (text.length() > TEXT_FILE_MAX_CHARS) {
                        text = text.substring(0, TEXT_FILE_MAX_CHARS) + "\n…（文档过长，已截断）";
                    }
                    textFiles.append("\n\n附件文档《").append(name).append("》内容：\n").append(text);
                } catch (Exception e) {
                    log.error("文本附件读取失败，跳过该附件，fileName={}", name, e);
                }
            } else {
                log.warn("不支持的附件类型，跳过：{}", name);
            }
        }
        prompt = prompt == null || prompt.isBlank()
                ? (images.isEmpty() ? "请结合我上传的文档进行分析并给出解释。" : DEFAULT_IMAGE_PROMPT)
                : prompt;
        if (textFiles.length() > 0) {
            prompt = prompt + textFiles;
        }
        Map<String, Object> textContent = new HashMap<>();
        textContent.put("text", prompt);
        contents.add(textContent);

        // 含 PDF 必须切 qwen3.8 系列（vl/omni 模型不收 PDF）
        String modelType = hasPdf ? "pdf" : "multimodal";
        String fallbackModel = hasPdf ? pdfModelName : visionModelName;
        return stream(contents, modelType, fallbackModel, sessionId, userId);
    }

    @Override
    @Tag(name = "fileMCPChat", description = "调用MCP并理解文件")
    public Flux<String> fileMCPChat(List<String> fileUrls, String prompt) {
        if (fileUrls == null || fileUrls.isEmpty()) {
            return Flux.error(new IllegalArgumentException("fileMCPChat 至少需要一个文档 URL"));
        }
        List<Map<String, Object>> contents = new ArrayList<>();
        for (String fileUrl : fileUrls) {
            Map<String, Object> fileContent = new HashMap<>();
            fileContent.put("file_url", fileUrl);
            contents.add(fileContent);
        }
        Map<String, Object> textContent = new HashMap<>();
        textContent.put("text", prompt == null || prompt.isBlank() ? "请总结这份文档的核心内容。" : prompt);
        contents.add(textContent);
        return stream(contents, "pdf", pdfModelName, null, null);
    }

    /** 拼装多模态消息并发起增量流式调用，Flowable 桥接 Flux 逐增量文本下发 */
    @Tag(name = "stream", description = "拼装多模态消息并发起增量流式调用")
    private Flux<String> stream(List<Map<String, Object>> contents, String modelType, String fallbackModel,
                                Long sessionId, Long userId) {
        MultiModalMessage userMessage = MultiModalMessage.builder()
                .role(Role.USER.getValue())
                .content(contents)
                .build();
        try {
            String model = activeModelService.resolveModelCode(modelType, fallbackModel);
            String activeApiKey = activeModelService.resolveApiKey(modelType, apiKey);
            MultiModalConversationParam param = MultiModalConversationParam.builder()
                    .apiKey(activeApiKey)
                    .model(model)
                    .messages(List.of(userMessage))
                    .incrementalOutput(true) // 增量输出：每帧只含新增文本，前端可直接拼接
                    .build();

            // 用量统计：末帧携带整轮 usage，doFinally 无论完成/异常/取消均落一条 model_call
            long start = System.currentTimeMillis();
            AtomicReference<MultiModalConversationResult> lastResult = new AtomicReference<>();
            AtomicBoolean errored = new AtomicBoolean(false);
            // streamCall 返回 RxJava Flowable（实现 Reactive Streams Publisher），直接桥接 Flux
            return Flux.from(new MultiModalConversation().streamCall(param))
                    .doOnNext(lastResult::set)
                    .map(this::deltaOf)
                    .filter(text -> !text.isEmpty())
                    .doOnError(e -> {
                        errored.set(true);
                        log.error("多模态流式调用失败，model={}", model, e);
                    })
                    .doFinally(signal -> recordUsage(model, start, lastResult.get(), errored.get(), sessionId, userId));
        } catch (Exception e) {
            // 构造参数/发起调用阶段的同步异常（NoApiKeyException 等）转为流错误
            log.error("多模态调用发起失败，model={}", fallbackModel, e);
            recordUsage(fallbackModel, System.currentTimeMillis(), null, true, sessionId, userId);
            return Flux.error(e);
        }
    }

    /** 多模态流用量落库：token 取末帧 usage（增量输出下部分帧可能缺 usage，取最后已知值），并记会话/用户归属 */
    private void recordUsage(String model, long start, MultiModalConversationResult last, boolean failed,
                             Long sessionId, Long userId) {
        try {
            Integer in = null;
            Integer out = null;
            if (last != null && last.getUsage() != null) {
                in = last.getUsage().getInputTokens();
                out = last.getUsage().getOutputTokens();
            }
            callStatisticsService.recordModelCall("综合问答·多模态", model,
                    System.currentTimeMillis() - start, in, out, !failed, sessionId, userId);
        } catch (Exception e) {
            log.warn("记录多模态用量统计失败，model={}", model, e);
        }
    }

    /** PDF 判定：扩展名或 MIME 命中即可 */
    private boolean isPdf(String fileName, String contentType) {
        return fileName.toLowerCase().endsWith(".pdf")
                || "application/pdf".equalsIgnoreCase(contentType);
    }

    /** 文本类文档判定（直接解析入提问） */
    private boolean isTextDoc(String fileName) {
        String lower = fileName.toLowerCase();
        return lower.endsWith(".txt") || lower.endsWith(".md");
    }


    /** 取流式帧中的增量文本；无文本的帧（如首帧/末帧）返回空串被 filter 掉 */
    private String deltaOf(MultiModalConversationResult result) {
        if (result == null || result.getOutput() == null) {
            return "";
        }
        List<MultiModalConversationOutput.Choice> choices = result.getOutput().getChoices();
        if (choices == null || choices.isEmpty()) {
            return "";
        }
        MultiModalMessage message = choices.get(0).getMessage();
        if (message == null || message.getContent() == null || message.getContent().isEmpty()) {
            return "";
        }
        Object text = message.getContent().get(0).get("text");
        return text == null ? "" : text.toString();
    }
}
