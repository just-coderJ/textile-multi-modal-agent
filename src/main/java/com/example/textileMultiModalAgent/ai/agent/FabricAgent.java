package com.example.textileMultiModalAgent.ai.agent;

import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversation;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationOutput;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationParam;
import com.alibaba.dashscope.aigc.multimodalconversation.MultiModalConversationResult;
import com.alibaba.dashscope.common.MultiModalMessage;
import com.alibaba.dashscope.common.Role;
import com.example.textileMultiModalAgent.common.core.AiJson;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.annotation.Resource;
import java.util.List;
import java.util.Map;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 面料识别 Agent：持有门禁/疵点两段视觉 prompt 与 DashScope 多模态同步调用。
 *
 * <p>复用综合问答图片链路的 multi-model 通道（本 Key 渠道 qwen-vl-max 未开通会 404，
 * qwen3-omni-flash 已验证可用）；模型侧报错原样抛出，由 FabricService 透出。</p>
 */
@Slf4j
@Component
public class FabricAgent extends BizAgent {

    /** 视觉模型名：与综合问答图片链路共用 multi-model 配置 */
    @Getter
    @Value("${langChain4j.community.dashscope.multi-model.model-name}")
    private String visionModelName;

    @Value("${langChain4j.community.dashscope.multi-model.api-key}")
    private String apiKey;

    /** 调用统计（百炼用量落 ai_business_log，供后台 Dashboard 聚合） */
    @Resource
    private CallStatisticsService callStatisticsService;

    @Resource
    private ActiveModelService activeModelService;

    private static final String GATE_PROMPT = """
            你是纺织品检验专家。请判断图片是否为面料/纺织品（梭织、针织、牛仔、印花布等）的实物特写照片。
            只输出一个 JSON 对象，不要解释、不要代码围栏：
            {"isFabric": true或false, "reason": "一句判定依据"}
            """;

    private static final String DETECT_PROMPT = """
            你是纺织品质检专家，按四分制检验图片中的布面质量。逐类检查常见疵点：断纬/断经、油污/渍痕、色差/色花、破洞/稀密路、竹节纱/棉结。
            只输出一个 JSON 对象，不要解释、不要代码围栏：
            {"defects":[{"name":"疵点名称","position":"图中位置描述（如 左中部 (x:120, y:340)）","grade":"严重程度 A/B/C（A 轻微、B 中等、C 严重）"}],"verdict":"一句综合评定，如 B 级品 · 建议降级处理或修复后复检"}
            未发现任何疵点时 defects 为空数组，verdict 给出 A 级评定。
            """;

    /**
     * 门禁判定：图片是否为面料实物特写。
     *
     * @param dataUri 图片 base64 data URI
     * @return 解析后的 {isFabric,reason} JSON；解析失败返回 null
     * @throws Exception 视觉模型调用失败，由 Service 透出原始报错
     */
    public JsonNode gate(String dataUri) throws Exception {
        return AiJson.parseTree(callVision(dataUri, GATE_PROMPT));
    }

    /**
     * 疵点检测：四分制逐类检查布面。
     *
     * @return 解析后的 {defects,verdict} JSON；解析失败返回 null
     * @throws Exception 视觉模型调用失败，由 Service 透出原始报错
     */
    public JsonNode detect(String dataUri) throws Exception {
        return AiJson.parseTree(callVision(dataUri, DETECT_PROMPT));
    }

    /** 同步多模态调用：一张图 + 一段指令，返回模型全文文本；耗时与 token 用量落调用统计 */
    private String callVision(String dataUri, String prompt) throws Exception {
        long start = System.currentTimeMillis();
        String model = activeModelService.resolveModelCode("multimodal", visionModelName);
        String activeApiKey = activeModelService.resolveApiKey("multimodal", apiKey);
        List<Map<String, Object>> contents = List.of(Map.of("image", dataUri), Map.of("text", prompt));
        MultiModalMessage userMessage = MultiModalMessage.builder()
                .role(Role.USER.getValue())
                .content(contents)
                .build();
        MultiModalConversationParam param = MultiModalConversationParam.builder()
                .apiKey(activeApiKey)
                .model(model)
                .messages(List.of(userMessage))
                .incrementalOutput(false) // 非流式：单帧返回全文，便于 JSON 解析
                .build();
        MultiModalConversationResult result;
        try {
            result = new MultiModalConversation().call(param);
        } catch (Exception e) {
            recordUsage(model, start, null, null, false);
            throw e;
        }
        if (result == null || result.getOutput() == null) {
            recordUsage(model, start, null, null, false);
            throw new IllegalStateException("视觉模型返回空结果");
        }
        List<MultiModalConversationOutput.Choice> choices = result.getOutput().getChoices();
        if (choices == null || choices.isEmpty() || choices.get(0).getMessage() == null) {
            recordUsage(model, start, null, null, false);
            throw new IllegalStateException("视觉模型返回空 choices");
        }
        StringBuilder text = new StringBuilder();
        for (Map<String, Object> content : choices.get(0).getMessage().getContent()) {
            Object value = content.get("text");
            if (value != null) {
                text.append(value);
            }
        }
        Integer in = result.getUsage() == null ? null : result.getUsage().getInputTokens();
        Integer out = result.getUsage() == null ? null : result.getUsage().getOutputTokens();
        recordUsage(model, start, in, out, true);
        return text.toString();
    }

    /** 视觉调用用量落库；统计失败仅记日志，不影响检测结果 */
    private void recordUsage(String model, long start, Integer in, Integer out, boolean success) {
        try {
            callStatisticsService.recordModelCall("面料疵点检测", model,
                    System.currentTimeMillis() - start, in, out, success);
        } catch (Exception e) {
            log.warn("记录面料视觉调用统计失败", e);
        }
    }
}
