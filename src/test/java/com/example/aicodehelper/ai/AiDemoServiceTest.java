package com.example.aicodehelper.ai;

import com.example.textileMultiModalAgent.ai.app.AiCodeHelperService;
import dev.langchain4j.service.Result;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AiDemoServiceTest {

    @Resource
    private AiCodeHelperService aiCodeHelperService;

    @Test
    void chat() {
        String result = aiCodeHelperService.Chat("你好");
        System.out.println(result);
    }

    @Test
    void chatWithMemory() {
        String result = aiCodeHelperService.Chat("你好，我是程序员Jim");
        System.out.println(result);
        String result2 = aiCodeHelperService.Chat("你好，我是谁？");
        System.out.println(result2);
    }

    @Test
    void chatForRecord() {

        String userMessage = "你好，我是Jim，帮我制定学习报告";
        AiCodeHelperService.Record result = aiCodeHelperService.ChatForRecord(userMessage);
        System.out.println(result);
    }


    @Test
    void testChatRag() {
        // 1.测试rag结果
        String userMessage = aiCodeHelperService.Chat("JAVA路线");
        // 2.输出
        System.out.println(userMessage);
    }

    @Test
    void testChatRagResult() {
        // 1.测试rag结果
        Result<String> userMessage = aiCodeHelperService.ChatWithRagResult("JAVA路线");
        // 2.输出
        System.out.println(userMessage.sources());
        System.out.println(userMessage.content());
    }

    @Test
    void testChatTools() {
        // 1.测试rag结果
        String userMessage = aiCodeHelperService.Chat("What is the square root of 475695037565?");
        // 2.输出
        System.out.println(userMessage);
    }

    @Test
    void chatMCP() {
        // 1.测试rag结果
        String userMessage = aiCodeHelperService.Chat("顺德怎么去？");
        // 2.输出
        System.out.println(userMessage);
    }

    @Test
    void chatGuardRails() {
        // 1.测试GuardRails
//        String userMessage = aiCodeHelperService.Chat("SB");
        String userMessage = aiCodeHelperService.Chat("Hi");
        // 2.输出
        System.out.println(userMessage);
    }

    @Test
    void chatWithListeners() {
        // 1.测试Listener
        String userMessage = aiCodeHelperService.Chat("Hi");
        // 2.输出
        System.out.println(userMessage);
    }
}