package com.example.textileMultiModalAgent.controller.ai;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.textileMultiModalAgent.common.annotation.RequiresPermissions;
import com.example.textileMultiModalAgent.common.core.AiJson;
import com.example.textileMultiModalAgent.common.core.Result;
import com.example.textileMultiModalAgent.domain.AiBusinessLog;
import com.example.textileMultiModalAgent.domain.AiModel;
import com.example.textileMultiModalAgent.service.admin.CallStatisticsService;
import com.example.textileMultiModalAgent.service.admin.AiBusinessLogService;
import com.example.textileMultiModalAgent.service.admin.AiModelService;
import com.fasterxml.jackson.databind.JsonNode;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * AI 模型管理接口。
 *
 * <p>除基础 CRUD 外，提供模型用量聚合、启停和「设为当前使用」能力；
 * 用量来自 ai_business_log 中本月的 model_call 记录，额度与到期时间由模型配置维护。</p>
 */
@Slf4j
@Tag(name = "模型管理", description = "多平台模型接入、额度、到期与启用状态")
@RestController
@RequestMapping("/agent/model")
public class AiModelController {

    private static final String DEFAULT_PLATFORM_CODE = "bailian";
    private static final String DEFAULT_PLATFORM_NAME = "阿里云百炼";
    private static final String DEFAULT_MODEL_TYPE = "chat";
    private static final String DEFAULT_USAGE_UNIT = "tokens";

    @Resource
    private AiModelService aiModelService;

    @Resource
    private AiBusinessLogService aiBusinessLogService;

    /**
     * 列表：支持按名称/编码模糊、状态过滤。
     */
    @Operation(summary = "模型配置列表")
    @RequiresPermissions("agent:model:list")
    @GetMapping("/list")
    public Result list(AiModel query) {
        LambdaQueryWrapper<AiModel> wrapper = new LambdaQueryWrapper<>();
        if (query != null) {
            if (StringUtils.hasText(query.getModel_name())) {
                wrapper.like(AiModel::getModel_name, query.getModel_name());
            }
            if (StringUtils.hasText(query.getModel_code())) {
                wrapper.like(AiModel::getModel_code, query.getModel_code());
            }
            if (query.getStatus() != null) {
                wrapper.eq(AiModel::getStatus, query.getStatus());
            }
            if (StringUtils.hasText(query.getPlatform_code())) {
                wrapper.eq(AiModel::getPlatform_code, query.getPlatform_code());
            }
            if (StringUtils.hasText(query.getModel_type())) {
                wrapper.eq(AiModel::getModel_type, query.getModel_type());
            }
        }
        wrapper.orderByDesc(AiModel::getIs_current).orderByDesc(AiModel::getId);
        return Result.success(aiModelService.list(wrapper));
    }

    /**
     * 模型管理页聚合数据：摘要卡片、平台概览、当前使用模型与本月用量。
     */
    @Operation(summary = "模型管理聚合数据")
    @RequiresPermissions("agent:model:list")
    @GetMapping("/overview")
    public Result overview() {
        List<AiModel> models = aiModelService.lambdaQuery()
                .orderByDesc(AiModel::getIs_current)
                .orderByDesc(AiModel::getId)
                .list();
        Map<String, long[]> usage = usageThisMonth();
        for (AiModel model : models) {
            long[] acc = usage.get(model.getModel_code());
            model.setUsed_tokens(acc == null ? 0L : acc[1]);
            model.setCall_count(acc == null ? 0L : acc[0]);
        }

        List<Map<String, Object>> platforms = aggregatePlatforms(models);
        List<Map<String, Object>> currentModels = new ArrayList<>();
        int enabled = 0;
        int current = 0;
        int quotaConfigured = 0;
        int usageWarn = 0;
        int usageDanger = 0;
        int unavailable = 0;
        Date now = new Date();
        for (AiModel model : models) {
            boolean isEnabled = Integer.valueOf(1).equals(model.getStatus());
            if (isEnabled) {
                enabled++;
            }
            if (isEnabled && Integer.valueOf(1).equals(model.getIs_current())) {
                current++;
                currentModels.add(currentModelView(model));
            }
            long quota = model.getQuota_total() == null ? 0L : model.getQuota_total();
            long used = usedValue(model);
            if (quota > 0) {
                quotaConfigured++;
                double percent = used * 100.0 / quota;
                if (percent >= 80) {
                    usageDanger++;
                } else if (percent >= 50) {
                    usageWarn++;
                }
            }
            if (model.getExpire_time() != null && model.getExpire_time().before(now)) {
                unavailable++;
            } else if (quota > 0 && used >= quota) {
                unavailable++;
            }
        }

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("total", models.size());
        summary.put("enabled", enabled);
        summary.put("current", current);
        summary.put("quotaConfigured", quotaConfigured);
        summary.put("usageWarn", usageWarn);
        summary.put("usageDanger", usageDanger);
        summary.put("unavailable", unavailable);
        summary.put("platformCount", platforms.size());

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("summary", summary);
        data.put("platforms", platforms);
        data.put("models", models);
        data.put("currentModels", currentModels);
        return Result.success(data);
    }

    /**
     * 详情。
     */
    @Operation(summary = "模型配置详情")
    @RequiresPermissions("agent:model:query")
    @GetMapping("/{id}")
    public Result getInfo(@PathVariable Long id) {
        return Result.success(aiModelService.getById(id));
    }

    /**
     * 新增。
     */
    @Operation(summary = "新增模型配置")
    @RequiresPermissions("agent:model:add")
    @PostMapping
    @Transactional(rollbackFor = Exception.class)
    public Result add(@RequestBody AiModel model) {
        if (!StringUtils.hasText(model.getModel_name())
                || !StringUtils.hasText(model.getModel_code())) {
            return Result.error("模型名称与编码不能为空");
        }
        normalize(model);
        if (Integer.valueOf(1).equals(model.getIs_current())) {
            clearCurrent(model.getModel_type(), null);
        }
        model.setCreate_time(new Date());
        model.setUpdate_time(new Date());
        return aiModelService.save(model) ? Result.success() : Result.error();
    }

    /**
     * 修改。
     */
    @Operation(summary = "修改模型配置")
    @RequiresPermissions("agent:model:edit")
    @PutMapping
    @Transactional(rollbackFor = Exception.class)
    public Result edit(@RequestBody AiModel model) {
        if (model.getId() == null) {
            return Result.error("修改失败，主键不能为空");
        }
        AiModel existing = aiModelService.getById(model.getId());
        if (existing == null) {
            return Result.error("模型不存在");
        }
        if (!StringUtils.hasText(model.getPlatform_code())) {
            model.setPlatform_code(existing.getPlatform_code());
        }
        if (!StringUtils.hasText(model.getPlatform_name())) {
            model.setPlatform_name(existing.getPlatform_name());
        }
        if (!StringUtils.hasText(model.getModel_type())) {
            model.setModel_type(existing.getModel_type());
        }
        normalize(model);
        if (Integer.valueOf(1).equals(model.getIs_current())) {
            clearCurrent(model.getModel_type(), model.getId());
        }
        model.setUpdate_time(new Date());
        return aiModelService.updateById(model) ? Result.success() : Result.error();
    }

    /**
     * 启用/停用模型；停用当前模型时同步取消「当前使用」标记。
     */
    @Operation(summary = "启用或停用模型")
    @RequiresPermissions("agent:model:edit")
    @PutMapping("/{id}/status")
    public Result updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            return Result.error("状态只能为 0 或 1");
        }
        AiModel model = aiModelService.getById(id);
        if (model == null) {
            return Result.error("模型不存在");
        }
        model.setStatus(status);
        model.setUpdate_time(new Date());
        if (status == 0) {
            model.setIs_current(0);
        }
        return aiModelService.updateById(model) ? Result.success() : Result.error();
    }

    /**
     * 将某个已启用模型设为同类型中的当前使用模型。
     */
    @Operation(summary = "设为当前使用模型")
    @RequiresPermissions("agent:model:edit")
    @PutMapping("/{id}/activate")
    @Transactional(rollbackFor = Exception.class)
    public Result activate(@PathVariable Long id) {
        AiModel model = aiModelService.getById(id);
        if (model == null) {
            return Result.error("模型不存在");
        }
        if (!Integer.valueOf(1).equals(model.getStatus())) {
            return Result.error("请先启用该模型");
        }
        clearCurrent(model.getModel_type(), id);
        model.setIs_current(1);
        model.setUpdate_time(new Date());
        return aiModelService.updateById(model) ? Result.success() : Result.error();
    }

    /**
     * 删除。
     */
    @Operation(summary = "删除模型配置")
    @RequiresPermissions("agent:model:remove")
    @DeleteMapping("/{id}")
    public Result remove(@PathVariable Long id) {
        return aiModelService.removeById(id) ? Result.success() : Result.error();
    }

    private void normalize(AiModel model) {
        if (!StringUtils.hasText(model.getPlatform_code())) {
            model.setPlatform_code(DEFAULT_PLATFORM_CODE);
        }
        if (!StringUtils.hasText(model.getPlatform_name())) {
            model.setPlatform_name(DEFAULT_PLATFORM_NAME);
        }
        if (!StringUtils.hasText(model.getModel_type())) {
            model.setModel_type(DEFAULT_MODEL_TYPE);
        }
        if (!StringUtils.hasText(model.getUsage_unit())) {
            model.setUsage_unit(DEFAULT_USAGE_UNIT);
        }
        if (model.getQuota_total() == null) {
            model.setQuota_total(0L);
        }
        if (model.getStatus() == null) {
            model.setStatus(1);
        }
        if (model.getIs_current() == null) {
            model.setIs_current(0);
        }
        if (model.getDeleted() == null) {
            model.setDeleted(0);
        }
        if (model.getIs_current() == 1 && model.getStatus() == 0) {
            model.setIs_current(0);
        }
    }

    private void clearCurrent(String modelType, Long exceptId) {
        if (!StringUtils.hasText(modelType)) {
            return;
        }
        aiModelService.lambdaUpdate()
                .eq(AiModel::getModel_type, modelType)
                .eq(AiModel::getIs_current, 1)
                .ne(exceptId != null, AiModel::getId, exceptId)
                .set(AiModel::getIs_current, 0)
                .update();
    }

    /**
     * 按 model_code 聚合本月 model_call 的调用次数与 token 用量。
     * ai_business_log 不可用时返回空 Map，保证管理页仍可展示配置。
     */
    private Map<String, long[]> usageThisMonth() {
        Map<String, long[]> result = new LinkedHashMap<>();
        try {
            Date start = Date.from(LocalDate.now().withDayOfMonth(1)
                    .atStartOfDay(ZoneId.systemDefault()).toInstant());
            List<AiBusinessLog> logs = aiBusinessLogService.lambdaQuery()
                    .eq(AiBusinessLog::getLog_type, CallStatisticsService.TYPE_MODEL_CALL)
                    .ge(AiBusinessLog::getCreate_time, start)
                    .list();
            for (AiBusinessLog row : logs) {
                JsonNode content = AiJson.parseTree(row.getLog_content());
                if (content == null || !content.isObject()) {
                    continue;
                }
                String model = content.path("model").asText("");
                if (!StringUtils.hasText(model)) {
                    continue;
                }
                long tokens = content.path("in").asLong(0) + content.path("out").asLong(0);
                long[] acc = result.computeIfAbsent(model, key -> new long[2]);
                acc[0]++;
                acc[1] += tokens;
            }
        } catch (Exception e) {
            log.warn("聚合模型用量失败，管理页将显示 0 用量", e);
        }
        return result;
    }

    private List<Map<String, Object>> aggregatePlatforms(List<AiModel> models) {
        Map<String, Map<String, Object>> grouped = new LinkedHashMap<>();
        for (AiModel model : models) {
            String code = StringUtils.hasText(model.getPlatform_code())
                    ? model.getPlatform_code() : DEFAULT_PLATFORM_CODE;
            Map<String, Object> item = grouped.computeIfAbsent(code, key -> {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("code", key);
                row.put("name", StringUtils.hasText(model.getPlatform_name())
                        ? model.getPlatform_name() : DEFAULT_PLATFORM_NAME);
                row.put("total", 0);
                row.put("enabled", 0);
                row.put("current", 0);
                return row;
            });
            item.put("total", (Integer) item.get("total") + 1);
            if (Integer.valueOf(1).equals(model.getStatus())) {
                item.put("enabled", (Integer) item.get("enabled") + 1);
            }
            if (Integer.valueOf(1).equals(model.getIs_current())) {
                item.put("current", (Integer) item.get("current") + 1);
            }
        }
        return new ArrayList<>(grouped.values());
    }

    private Map<String, Object> currentModelView(AiModel model) {
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("id", model.getId());
        item.put("model_name", model.getModel_name());
        item.put("model_code", model.getModel_code());
        item.put("model_type", model.getModel_type());
        item.put("platform_code", model.getPlatform_code());
        item.put("platform_name", model.getPlatform_name());
        item.put("usage_unit", model.getUsage_unit());
        item.put("used_tokens", model.getUsed_tokens());
        item.put("call_count", model.getCall_count());
        return item;
    }

    /**
     * 按额度单位取本月已用量：token 模型取输入+输出 token，按次模型取调用次数。
     */
    private long usedValue(AiModel model) {
        if ("times".equalsIgnoreCase(model.getUsage_unit())) {
            return model.getCall_count() == null ? 0L : model.getCall_count();
        }
        return model.getUsed_tokens() == null ? 0L : model.getUsed_tokens();
    }
}
