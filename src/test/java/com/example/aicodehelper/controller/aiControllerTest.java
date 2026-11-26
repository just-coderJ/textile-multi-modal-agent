package com.example.aicodehelper.controller;

import com.example.textileMultiModalAgent.controller.ai.AiQAController;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.test.context.ActiveProfiles;
import reactor.core.publisher.Flux;

@SpringBootTest
@ActiveProfiles("local")
class AiControllerTest {

    @Resource
    private AiQAController aiQAController;


    @Test
    void chatWithServerSentEvent() {
        // 1.测试Listener
        Flux<ServerSentEvent<String>> userMessage = aiQAController.chat(12, "Hi", null);
        // 2.输出
        System.out.println(userMessage);
    }

}