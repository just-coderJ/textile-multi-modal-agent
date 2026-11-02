package com.example.textileMultiModalAgent.ai.model;

import com.example.textileMultiModalAgent.service.admin.ActiveModelService;
import com.example.textileMultiModalAgent.service.admin.ActiveModelService.ModelRuntime;
import dev.langchain4j.community.model.dashscope.QwenStreamingChatModel;
import dev.langchain4j.model.chat.StreamingChatModel;
import dev.langchain4j.model.chat.listener.ChatModelListener;
import dev.langchain4j.model.chat.request.ChatRequest;
import dev.langchain4j.model.chat.request.ChatRequestParameters;
import dev.langchain4j.model.chat.response.StreamingChatResponseHandler;
import java.util.List;

/**
 * 流式对话模型动态代理：每次调用读取「模型管理」中的当前 streaming 模型。
 */
public class DynamicStreamingChatModel implements StreamingChatModel {

    private final String fallbackModelCode;
    private final String fallbackApiKey;
    private final List<ChatModelListener> listeners;
    private final ActiveModelService activeModelService;

    public DynamicStreamingChatModel(String fallbackModelCode, String fallbackApiKey,
                                     List<ChatModelListener> listeners,
                                     ActiveModelService activeModelService) {
        this.fallbackModelCode = fallbackModelCode;
        this.fallbackApiKey = fallbackApiKey;
        this.listeners = listeners;
        this.activeModelService = activeModelService;
    }

    private QwenStreamingChatModel delegate() {
        ModelRuntime runtime = activeModelService.resolveRuntime(
                "streaming", fallbackModelCode, fallbackApiKey);
        QwenStreamingChatModel.QwenStreamingChatModelBuilder builder = QwenStreamingChatModel.builder()
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
    public void doChat(ChatRequest request, StreamingChatResponseHandler handler) {
        delegate().doChat(request, handler);
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
