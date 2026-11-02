package com.example.textileMultiModalAgent.ai.model;

import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.chat.listener.ChatModelListener;
import jakarta.annotation.Resource;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
@ConfigurationProperties(prefix = "langchain4j.community.dashscope.chat-model")
@Data
public class QwenChatModelConfig {

    private String modelName;

    private String apiKey;

    @Resource
    private ChatModelListener chatModelListener;

    @Resource
    private ActiveModelService activeModelService;

    @Bean
    public ChatModel myQwenChatModel() {
        return new DynamicChatModel(modelName, apiKey,
                List.of(chatModelListener), activeModelService);
    }
}
