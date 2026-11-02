package com.example.textileMultiModalAgent.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import lombok.Data;

/**
 * AI大模型配置表
 *
 * 注意：仓库 sql/create_table.sql 中未包含 ai_model 建表语句，本实体结构为推断，
 * 依据：旧表 sys_agent_model 字段 + 新表通用约定(id/create_time/update_time/deleted)
 * + ai_chat_session.model_id / ai_prompt_template.model_id 注释"关联ai_model主键"
 * + 前端「模型配置」列(name/code/temperature/maxTokens/status)。
 * 若实际表结构不同，请以此为准调整字段。
 *
 * @TableName ai_model
 */
@TableName(value ="ai_model")
@Data
public class AiModel implements Serializable {
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 模型展示名称
     */
    @TableField(value = "model_name")
    private String model_name;

    /**
     * 模型平台编码：bailian / openai / zhipu ...
     */
    @TableField(value = "platform_code")
    private String platform_code;

    /**
     * 模型平台展示名称
     */
    @TableField(value = "platform_name")
    private String platform_name;

    /**
     * 模型编码 deepseek-r1 / qwen-max / qwen3-omni-flash
     */
    @TableField(value = "model_code")
    private String model_code;

    /**
     * 模型类型：chat / multimodal / pdf / embedding / streaming / asr
     */
    @TableField(value = "model_type")
    private String model_type;

    /**
     * 接口地址
     */
    @TableField(value = "base_url")
    private String base_url;

    /**
     * 密钥
     */
    @TableField(value = "api_key")
    private String api_key;

    /**
     * 温度
     */
    @TableField(value = "temperature")
    private BigDecimal temperature;

    /**
     * 最大输出token
     */
    @TableField(value = "max_tokens")
    private Integer max_tokens;

    /**
     * 周期额度（usage_unit 为 tokens 时表示 token 数）
     */
    @TableField(value = "quota_total")
    private Long quota_total;

    /**
     * 额度单位：tokens / times
     */
    @TableField(value = "usage_unit")
    private String usage_unit;

    /**
     * 到期时间
     */
    @TableField(value = "expire_time")
    private Date expire_time;

    /**
     * 是否当前使用：1是 0否（同一 model_type 仅一条为当前）
     */
    @TableField(value = "is_current")
    private Integer is_current;

    /**
     * 状态：1启用 0停用
     */
    @TableField(value = "status")
    private Integer status;

    /**
     * 备注
     */
    @TableField(value = "remark")
    private String remark;

    /**
     * 创建时间
     */
    @TableField(value = "create_time")
    private Date create_time;

    /**
     * 更新时间
     */
    @TableField(value = "update_time")
    private Date update_time;

    /**
     * 逻辑删除
     */
    @TableField(value = "deleted")
    private Integer deleted;

    /**
     * 本月已用 token（聚合 ai_business_log，不落库）
     */
    @TableField(exist = false)
    private Long used_tokens;

    /**
     * 本月调用次数（聚合 ai_business_log，不落库）
     */
    @TableField(exist = false)
    private Long call_count;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
}
