package com.example.textileMultiModalAgent.service.admin;

import com.example.textileMultiModalAgent.domain.AiModel;
import jakarta.annotation.Resource;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
 * 运行时当前模型解析：多模态 / PDF / ASR 调用前读取「模型管理」中同类型已启用的当前模型。
 *
 * <p>兼容尚未执行迁移脚本的库：ai_model 不可用时自动回退 application 配置；
 * 一旦该类型存在管理记录，则必须存在已启用的当前模型，避免后台停用后仍继续调用。</p>
 */
@Slf4j
@Service
public class ActiveModelService {

    private static final AtomicBoolean WARNED = new AtomicBoolean(false);

    @Resource
    private AiModelService aiModelService;

    /**
     * 返回当前模型编码；没有管理记录时回退配置文件中的模型。
     */
    public String resolveModelCode(String modelType, String fallbackModelCode) {
        AiModel current = findCurrent(modelType);
        if (current == null) {
            return fallbackModelCode;
        }
        return StringUtils.hasText(current.getModel_code())
                ? current.getModel_code() : fallbackModelCode;
    }

    /**
     * 返回当前模型密钥；管理记录未填写时回退配置文件中的密钥。
     */
    public String resolveApiKey(String modelType, String fallbackApiKey) {
        AiModel current = findCurrent(modelType);
        if (current == null || !StringUtils.hasText(current.getApi_key())) {
            return fallbackApiKey;
        }
        return current.getApi_key();
    }

    /**
     * 一次查询解析运行时所需的模型参数；未配置当前模型时完整回退配置文件。
     */
    public ModelRuntime resolveRuntime(String modelType, String fallbackModelCode, String fallbackApiKey) {
        AiModel current = findCurrent(modelType);
        if (current == null) {
            return new ModelRuntime(fallbackModelCode, fallbackApiKey, null, null);
        }
        String modelCode = StringUtils.hasText(current.getModel_code())
                ? current.getModel_code() : fallbackModelCode;
        String apiKey = StringUtils.hasText(current.getApi_key())
                ? current.getApi_key() : fallbackApiKey;
        Float temperature = current.getTemperature() == null
                ? null : current.getTemperature().floatValue();
        return new ModelRuntime(modelCode, apiKey, temperature, current.getMax_tokens());
    }

    private AiModel findCurrent(String modelType) {
        try {
            List<AiModel> models = aiModelService.lambdaQuery()
                    .eq(AiModel::getModel_type, modelType)
                    .list();
            if (models.isEmpty()) {
                return null;
            }
            for (AiModel model : models) {
                if (Integer.valueOf(1).equals(model.getStatus())
                        && Integer.valueOf(1).equals(model.getIs_current())) {
                    return model;
                }
            }
            throw new IllegalStateException("模型类型「" + modelType
                    + "」没有启用的当前模型，请在后台模型管理中启用并设为当前");
        } catch (IllegalStateException e) {
            throw e;
        } catch (Exception e) {
            if (WARNED.compareAndSet(false, true)) {
                log.warn("读取模型管理配置失败，将回退 application 配置：{}", e.getMessage());
            }
            return null;
        }
    }

    /**
     * 运行时模型参数快照。
     */
    public record ModelRuntime(String modelCode, String apiKey, Float temperature, Integer maxTokens) {
    }
}
