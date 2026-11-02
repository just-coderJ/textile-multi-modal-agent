package com.example.textileMultiModalAgent.controller.ai;

import com.example.textileMultiModalAgent.common.core.Result;
import com.example.textileMultiModalAgent.service.ai.KnowledgeBaseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 知识库管理接口（文档落 MinIO + 向量化 + 启停管理）。
 * 映射路径 /knowledge，完整 URL /api/knowledge（context-path=/api），处于 JWT 拦截范围内。
 */
@Tag(name = "知识库管理", description = "文档上传/向量化/启用停用/重索引/删除")
@RestController
@RequestMapping("/knowledge")
public class KnowledgeController {

    @Resource
    private KnowledgeBaseService knowledgeBaseService;

    /**
     * 上传知识库文档（md/txt/pdf）。
     *
     * @param file   文档
     * @param kbType 分类：process/business/competitor，缺省 business
     */
    @Operation(summary = "上传知识库文档")
    @PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file,
                         @RequestParam(value = "kbType", required = false) String kbType) {
        try {
            return Result.success("上传成功", knowledgeBaseService.upload(file, kbType));
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 文档列表。
     */
    @Operation(summary = "知识库文档列表")
    @GetMapping("/list")
    public Result list() {
        return Result.success(knowledgeBaseService.list());
    }

    /**
     * 启用/停用文档（停用即从检索向量库移除）。
     *
     * @param enabled true 启用 / false 停用
     */
    @Operation(summary = "启用或停用文档")
    @PutMapping("/{id}/enabled")
    public Result setEnabled(@PathVariable("id") Long id, @RequestParam("enabled") boolean enabled) {
        try {
            knowledgeBaseService.setEnabled(id, enabled);
            return Result.success();
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("操作失败：" + e.getMessage());
        }
    }

    /**
     * 重索引：强制重走向量化。
     */
    @Operation(summary = "重索引文档")
    @PostMapping("/{id}/reindex")
    public Result reindex(@PathVariable("id") Long id) {
        try {
            knowledgeBaseService.reindex(id);
            return Result.success();
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("重索引失败：" + e.getMessage());
        }
    }

    /**
     * 删除文档（移除向量 + 删除 MinIO 对象 + 逻辑删除）。
     */
    @Operation(summary = "删除文档")
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable("id") Long id) {
        try {
            knowledgeBaseService.delete(id);
            return Result.success();
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}
