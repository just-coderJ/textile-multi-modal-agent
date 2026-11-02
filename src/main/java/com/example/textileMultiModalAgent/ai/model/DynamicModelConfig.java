package com.example.textileMultiModalAgent.ai.model;

import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import dev.langchain4j.model.chat.StreamingChatModel;
import dev.langchain4j.model.chat.listener.ChatModelListener;
import dev.langchain4j.model.embedding.EmbeddingModel;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

/**
 * 流式与向量模型的动态代理 Bean；文本模型由 {@link QwenChatModelConfig} 创建。
 */
@Configuration
public class DynamicModelConfig {

    @Bean
    @Primary
    public StreamingChatModel dynamicStreamingChatModel(
            @Value("${langChain4j.community.dashscope.streaming-chat-model.model-name:qwen-max}")
            String fallbackModelCode,
            @Value("${langChain4j.community.dashscope.streaming-chat-model.api-key}")
            String fallbackApiKey,
            ChatModelListener listener,
            ActiveModelService activeModelService) {
        return new DynamicStreamingChatModel(fallbackModelCode, fallbackApiKey,
                List.of(listener), activeModelService);
    }

    @Bean
    @Primary
    public EmbeddingModel dynamicEmbeddingModel(
            @Value("${langChain4j.community.dashscope.embedding-model.model-name:text-embedding-async-v1}")
            String fallbackModelCode,
            @Value("${langChain4j.community.dashscope.embedding-model.api-key}")
            String fallbackApiKey,
            ActiveModelService activeModelService,
            CallStatisticsService callStatisticsService) {
        return new DynamicEmbeddingModel(fallbackModelCode, fallbackApiKey,
                activeModelService, callStatisticsService);
    }
}
