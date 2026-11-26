package com.example.aicodehelper;

import com.example.textileMultiModalAgent.ai.app.AiDemo;
import dev.langchain4j.data.message.ImageContent;
import dev.langchain4j.data.message.TextContent;
import dev.langchain4j.data.message.UserMessage;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import  jakarta.annotation.Resource;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("local")
class AiDemoApplicationTests {

    @Resource
    private AiDemo aiDemo;

    @Test
    void contextLoads() {
    }

    @Test
    void chat() {
        System.out.println(aiDemo.Chat("你好, 这里是程序员Jim"));
        // 结果与chatWithMemory做对比，这里是没有会话记忆无法得知我身份的
        String result2 = aiDemo.Chat("你好，我是谁？");
        System.out.println(result2);
    }


    @Test
    void testChat() {
        // 1.封装UserMessage
        UserMessage userMessage = UserMessage.from(
            TextContent.from("给你一张表情包~"),
            ImageContent.from("https://c-ssl.dtstatic.com/uploads/blog/202303/24/20230324044542_2f62d.thumb.1000_0.jpeg")
        );
        // 2.调用chat方法
        aiDemo.Chat(userMessage);
    }


}
