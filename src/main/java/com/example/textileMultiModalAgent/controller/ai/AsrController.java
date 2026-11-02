package com.example.textileMultiModalAgent.controller.ai;

import com.alibaba.dashscope.audio.asr.recognition.Recognition;
import com.alibaba.dashscope.audio.asr.recognition.RecognitionParam;
import com.example.textileMultiModalAgent.common.core.AiJson;
import com.example.textileMultiModalAgent.common.core.Result;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.fasterxml.jackson.databind.JsonNode;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.util.Map;

/**
 * 语音识别接口（综合问答语音输入）：接收前端录制的 16k 单声道 WAV，
 * 调百炼 paraformer 同步识别，返回 {text}。
 *
 * <p>Web Speech API 依赖 Google 语音服务，国内网络基本不可用，故改走服务端 ASR：
 * 前端 AudioContext 采集 PCM → 降采样 16k → WAV 编码 → multipart 上送本接口。</p>
 *
 * <p>属 /ai/** 公开入口（免鉴权），录音不落 MinIO，仅识别即弃。</p>
 */
@RestController
@RequestMapping("/ai")
@Tag(name = "AsrController", description = "语音识别接口（百炼 paraformer）")
@Slf4j
public class AsrController {

    /** 复用多模态渠道的 DashScope apiKey（与综合问答/面料识别同 Key） */
    @Value("${langChain4j.community.dashscope.multi-model.api-key}")
    private String apiKey;

    /** ASR 模型名：paraformer-realtime-v2 支持采样率自适应，短录音同步识别够用 */
    @Value("${asr.model-name:paraformer-realtime-v2}")
    private String asrModelName;

    @Resource
    private CallStatisticsService callStatisticsService;

    @Resource
    private ActiveModelService activeModelService;

    @Operation(summary = "语音转文字", description = "上传 wav 音频（16k 单声道），返回识别文本")
    @PostMapping("/asr")
    public Result asr(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return Result.error("音频为空");
        }
        long start = System.currentTimeMillis();
        File temp = null;
        try {
            temp = File.createTempFile("asr-", ".wav");
            file.transferTo(temp);
            String model = activeModelService.resolveModelCode("asr", asrModelName);
            String activeApiKey = activeModelService.resolveApiKey("asr", apiKey);
            RecognitionParam param = RecognitionParam.builder()
                    .model(model)
                    .format("wav")
                    .sampleRate(16000)
                    .apiKey(activeApiKey)
                    .build();
            // 同步整段识别：SDK 返回聚合结果 JSON（含 sentences 数组），
            // 需抽取每句 text 拼接为纯文本；旧版直出纯文本时降级原样返回
            String raw = new Recognition().call(param, temp);
            String text = extractAsrText(raw);
            callStatisticsService.recordModelCall("语音识别", model,
                    System.currentTimeMillis() - start, null, null, true);
            return Result.success(Map.of("text", text == null ? "" : text));
        } catch (Exception e) {
            log.error("语音识别失败，model={}", asrModelName, e);
            callStatisticsService.recordModelCall("语音识别", asrModelName,
                    System.currentTimeMillis() - start, null, null, false);
            String reason = e.getMessage() == null ? e.getClass().getSimpleName() : e.getMessage();
            return Result.error("语音识别失败：" + reason);
        } finally {
            if (temp != null) {
                try {
                    Files.deleteIfExists(temp.toPath());
                } catch (Exception ignored) {
                    // 临时文件清理失败不影响结果
                }
            }
        }
    }

    /**
     * 从 paraformer 返回体中抽取纯文本。
     *
     * <p>识别结果为形如 {@code {"sentences":[{"text":"..."},...]}} 的 JSON，
     * 逐句拼接 sentences[].text；无法解析（例如 SDK 版本直接返回纯文本）时原样返回。</p>
     */
    private String extractAsrText(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        JsonNode root = AiJson.parseTree(raw);
        if (root == null) {
            return raw.trim();
        }
        JsonNode sentences = root.path("sentences");
        if (sentences.isArray() && !sentences.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            for (JsonNode sentence : sentences) {
                sb.append(sentence.path("text").asText(""));
            }
            String joined = sb.toString().trim();
            if (!joined.isEmpty()) {
                return joined;
            }
        }
        // 兜底：单句结构 {text:"..."}
        String single = root.path("text").asText("");
        return single.isBlank() ? raw.trim() : single;
    }
}
