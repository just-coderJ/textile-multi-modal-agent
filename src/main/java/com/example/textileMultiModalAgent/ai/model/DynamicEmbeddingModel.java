package com.example.textileMultiModalAgent.ai.model;

import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService.ModelRuntime;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import dev.langchain4j.community.model.dashscope.QwenEmbeddingModel;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.output.Response;
import dev.langchain4j.model.output.TokenUsage;
import java.util.List;

/**
 * 向量模型动态代理：每次向量化读取「模型管理」中的当前 embedding 模型。
 */
public class DynamicEmbeddingModel implements EmbeddingModel {

    private final String fallbackModelCode;
    private final String fallbackApiKey;
    private final ActiveModelService activeModelService;
    private final CallStatisticsService callStatisticsService;

    public DynamicEmbeddingModel(String fallbackModelCode, String fallbackApiKey,
                                 ActiveModelService activeModelService,
                                 CallStatisticsService callStatisticsService) {
        this.fallbackModelCode = fallbackModelCode;
        this.fallbackApiKey = fallbackApiKey;
        this.activeModelService = activeModelService;
        this.callStatisticsService = callStatisticsService;
    }

    @Override
    public Response<List<Embedding>> embedAll(List<TextSegment> segments) {
        ModelRuntime runtime = activeModelService.resolveRuntime(
                "embedding", fallbackModelCode, fallbackApiKey);
        long start = System.currentTimeMillis();
        try {
            Response<List<Embedding>> response = QwenEmbeddingModel.builder()
                    .modelName(runtime.modelCode())
                    .apiKey(runtime.apiKey())
                    .build()
                    .embedAll(segments);
            TokenUsage usage = response.tokenUsage();
            callStatisticsService.recordModelCall("\u77e5\u8bc6\u5e93\u5411\u91cf\u5316", runtime.modelCode(),
                    System.currentTimeMillis() - start,
                    usage == null ? null : usage.inputTokenCount(),
                    usage == null ? null : usage.outputTokenCount(), true);
            return response;
        } catch (Exception e) {
            callStatisticsService.recordModelCall("\u77e5\u8bc6\u5e93\u5411\u91cf\u5316", runtime.modelCode(),
                    System.currentTimeMillis() - start, null, null, false);
            throw e;
        }
    }
}
