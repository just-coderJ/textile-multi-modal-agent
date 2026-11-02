package com.example.textileMultiModalAgent.ai.model;

import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService.ModelRuntime;
import dev.langchain4j.community.model.dashscope.QwenChatModel;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.chat.listener.ChatModelListener;
import dev.langchain4j.model.chat.request.ChatRequest;
import dev.langchain4j.model.chat.request.ChatRequestParameters;
import dev.langchain4j.model.chat.response.ChatResponse;
import java.util.List;

/**
 * 文本对话模型动态代理：每次调用读取「模型管理」中的当前 chat 模型。
 */
public class DynamicChatModel implements ChatModel {

    private final String fallbackModelCode;
    private final String fallbackApiKey;
    private final List<ChatModelListener> listeners;
    private final ActiveModelService activeModelService;

    public DynamicChatModel(String fallbackModelCode, String fallbackApiKey,
                            List<ChatModelListener> listeners,
                            ActiveModelService activeModelService) {
        this.fallbackModelCode = fallbackModelCode;
        this.fallbackApiKey = fallbackApiKey;
        this.listeners = listeners;
        this.activeModelService = activeModelService;
    }

    private QwenChatModel delegate() {
        ModelRuntime runtime = activeModelService.resolveRuntime(
                "chat", fallbackModelCode, fallbackApiKey);
        QwenChatModel.QwenChatModelBuilder builder = QwenChatModel.builder()
                .modelName(runtime.modelCode())
                .apiKey(runtime.apiKey());
        if (runtime.temperature() != null) {
            builder.temperature(runtime.temperature());
        }
        if (runtime.maxTokens() != null) {
            builder.maxTokens(runtime.maxTokens());
        }
        return builder.build();
    }

    @Override
    public ChatResponse doChat(ChatRequest request) {
        return delegate().doChat(request);
    }

    @Override
    public ChatRequestParameters defaultRequestParameters() {
        return delegate().defaultRequestParameters();
    }

    @Override
    public List<ChatModelListener> listeners() {
        return listeners;
    }
}
