package com.example.textileMultiModalAgent.ai.app;

import com.example.textileMultiModalAgent.ai.mcp.McpConfig;
//import com.example.textileMultiModalAgent.ai.model.TextOnlyStreamingChatModel;
import com.example.textileMultiModalAgent.ai.tools.MathTools;
import dev.langchain4j.guardrail.InputGuardrail;
import dev.langchain4j.mcp.McpToolProvider;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatModel;
import dev.langchain4j.model.chat.StreamingChatModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.service.AiServices;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Qualifier;

@Configuration
@Tag(name = "AiCodeHelperFactory", description = "ChatModel自定义配置")
public class AiCodeHelperFactory
{

    @Resource
    private ChatModel myQwenChatModel; // 这个chatModel携带了监听器，相当于仿制了一个chatModel

    @Resource
    private ContentRetriever contentRetriever;
    @Resource
    private McpConfig mcpConfig;
    /** MCP 未配置时 Bean 为 null，用 ObjectProvider 安全获取，避免强依赖拖垮启动 */
    @Resource
    private org.springframework.beans.factory.ObjectProvider<McpToolProvider> mcpToolProviderProvider;

    @Resource
    private InputGuardrail inputGuardrail;

    @Resource
    @Qualifier("dynamicStreamingChatModel")
    private StreamingChatModel qwenStreamingChatModel;

    @Bean
    public AiCodeHelperService aiCodeHelperService() {
        // 会话记忆
        ChatMemory chatMemory = MessageWindowChatMemory.withMaxMessages(10);

        // 构建AI服务
        AiServices<AiCodeHelperService> builder = AiServices.builder(AiCodeHelperService.class)
                .chatModel(myQwenChatModel)
                // 文本模型回放共享记忆时剥离图片等多模态内容，避免 qwen-max 报错
                .streamingChatModel(qwenStreamingChatModel) // 流式输出
                .chatMemory(chatMemory) // 会话记忆
                .chatMemoryProvider(memoryId -> MessageWindowChatMemory.withMaxMessages(10)) // 每个会话独立存储
                .contentRetriever(contentRetriever) // Rag检索生成
                .tools(new MathTools()) // 工具调用
                .inputGuardrails(inputGuardrail);
        McpToolProvider mcpToolProvider = mcpToolProviderProvider.getIfAvailable();
        if (mcpToolProvider != null) {
            builder.toolProvider(mcpToolProvider); // mcp工具调用
        }
        return builder.build();
    }
}



