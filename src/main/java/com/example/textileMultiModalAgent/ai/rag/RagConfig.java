package com.example.textileMultiModalAgent.ai.rag;

import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RAG 检索配置。
 *
 * <p>{@link EmbeddingStore} 提为单例 Bean（InMemoryEmbeddingStore），供 KnowledgeBaseService
 * 写入/清理向量与 ContentRetriever 检索共享同一份存储；进程重启即空，启动时由
 * KnowledgeBaseService 遍历 enabled=1 的文档重建（pgvector 持久化作后续演进）。</p>
 */
@Configuration
public class RagConfig {

    @Resource
    @Qualifier("dynamicEmbeddingModel")
    private EmbeddingModel embeddingModel;

    /** 全局共享向量库：知识库写入与问答检索指向同一实例 */
    @Bean
    public EmbeddingStore<TextSegment> embeddingStore() {
        return new InMemoryEmbeddingStore<>();
    }

    @Bean
    public ContentRetriever contentRetriever(EmbeddingStore<TextSegment> embeddingStore) {
        return EmbeddingStoreContentRetriever.builder()
                .embeddingStore(embeddingStore)
                .embeddingModel(embeddingModel)
                .maxResults(5) // 最多5条结果
                .minScore(0.75) // 过滤掉分数小于0.75的结果
                .build();
    }
}
