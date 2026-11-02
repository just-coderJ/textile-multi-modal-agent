-- 模型管理增量脚本（可重复执行）
-- 适用：已有 ai_model 基础表的存量库；全新库可直接执行 create_table.sql + init_data.sql

CREATE TABLE IF NOT EXISTS ai_model (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    platform_code   VARCHAR(32)   NOT NULL DEFAULT 'bailian' COMMENT '平台编码',
    platform_name   VARCHAR(64)   NOT NULL DEFAULT '阿里云百炼' COMMENT '平台展示名称',
    model_name      VARCHAR(128)  NOT NULL COMMENT '模型展示名称',
    model_code      VARCHAR(128)  NOT NULL COMMENT '模型编码',
    model_type      VARCHAR(32)   NOT NULL DEFAULT 'chat' COMMENT 'chat/multimodal/pdf/embedding/streaming/asr',
    base_url        VARCHAR(512)  DEFAULT '' COMMENT '接口地址',
    api_key         VARCHAR(512)  DEFAULT '' COMMENT '接口密钥',
    temperature     DECIMAL(3,2)  DEFAULT 0.70 COMMENT '温度',
    max_tokens      INT           DEFAULT 2048 COMMENT '最大输出 token',
    quota_total     BIGINT        NOT NULL DEFAULT 0 COMMENT '周期额度，0 表示未配置',
    usage_unit      VARCHAR(16)   NOT NULL DEFAULT 'tokens' COMMENT 'tokens/times',
    expire_time     DATETIME      NULL COMMENT '到期时间',
    is_current      TINYINT       NOT NULL DEFAULT 0 COMMENT '当前使用：0-否 1-是',
    status          TINYINT       NOT NULL DEFAULT 1 COMMENT '状态：0-停用 1-启用',
    remark          VARCHAR(500)  DEFAULT '' COMMENT '备注',
    create_time     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted         TINYINT       NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-否 1-是',
    UNIQUE KEY uk_ai_model_platform_type (platform_code, model_code, model_type),
    KEY idx_ai_model_type_current (model_type, is_current),
    KEY idx_ai_model_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI 大模型接入与额度配置表';

-- 老表补列：仅当列不存在时执行 ALTER
DROP PROCEDURE IF EXISTS add_ai_model_column;
DELIMITER $$
CREATE PROCEDURE add_ai_model_column(IN column_name VARCHAR(64), IN ddl TEXT)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ai_model' AND COLUMN_NAME = column_name
    ) THEN
        SET @ddl_sql = ddl;
        PREPARE stmt FROM @ddl_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL add_ai_model_column('platform_code', 'ALTER TABLE ai_model ADD COLUMN platform_code VARCHAR(32) NOT NULL DEFAULT ''bailian'' COMMENT ''平台编码'' AFTER id');
CALL add_ai_model_column('platform_name', 'ALTER TABLE ai_model ADD COLUMN platform_name VARCHAR(64) NOT NULL DEFAULT ''阿里云百炼'' COMMENT ''平台展示名称'' AFTER platform_code');
CALL add_ai_model_column('model_type', 'ALTER TABLE ai_model ADD COLUMN model_type VARCHAR(32) NOT NULL DEFAULT ''chat'' COMMENT ''模型类型'' AFTER model_code');
CALL add_ai_model_column('quota_total', 'ALTER TABLE ai_model ADD COLUMN quota_total BIGINT NOT NULL DEFAULT 0 COMMENT ''周期额度'' AFTER max_tokens');
CALL add_ai_model_column('usage_unit', 'ALTER TABLE ai_model ADD COLUMN usage_unit VARCHAR(16) NOT NULL DEFAULT ''tokens'' COMMENT ''额度单位'' AFTER quota_total');
CALL add_ai_model_column('expire_time', 'ALTER TABLE ai_model ADD COLUMN expire_time DATETIME NULL COMMENT ''到期时间'' AFTER usage_unit');
CALL add_ai_model_column('is_current', 'ALTER TABLE ai_model ADD COLUMN is_current TINYINT NOT NULL DEFAULT 0 COMMENT ''当前使用'' AFTER expire_time');

DROP PROCEDURE IF EXISTS add_ai_model_column;

-- 首次接入的百炼模型（已有同平台/编码/类型则跳过）
UPDATE sys_menu
SET menu_name = '模型管理',
    remark = '模型平台、额度、到期与启停管理'
WHERE menu_id = 2005;

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', '通义千问 Max', 'qwen-max', 'chat',
       'https://dashscope.aliyuncs.com/compatible-mode/v1', '', 0.70, 2048, 1000000, 'tokens',
       date_add(sysdate(), interval 30 day), 1, 1, '文本对话主模型'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'qwen-max' AND model_type = 'chat');

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', 'Qwen Omni Flash', 'qwen3-omni-flash', 'multimodal',
       'https://dashscope.aliyuncs.com', '', 0.70, 4096, 800000, 'tokens',
       date_add(sysdate(), interval 30 day), 1, 1, '综合问答图片与面料识别'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'qwen3-omni-flash' AND model_type = 'multimodal');

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', 'Qwen3.8 Flash', 'qwen3.8-flash', 'pdf',
       'https://dashscope.aliyuncs.com', '', 0.70, 4096, 500000, 'tokens',
       date_add(sysdate(), interval 30 day), 1, 1, 'PDF 文档理解'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'qwen3.8-flash' AND model_type = 'pdf');

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', 'Text Embedding Async', 'text-embedding-async-v1', 'embedding',
       'https://dashscope.aliyuncs.com', '', 0.70, 2048, 2000000, 'tokens',
       date_add(sysdate(), interval 30 day), 1, 1, '知识库向量化'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'text-embedding-async-v1' AND model_type = 'embedding');

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', '通义千问 Max 流式', 'qwen-max', 'streaming',
       'https://dashscope.aliyuncs.com/compatible-mode/v1', '', 0.70, 2048, 1000000, 'tokens',
       date_add(sysdate(), interval 30 day), 1, 1, '流式输出'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'qwen-max' AND model_type = 'streaming');

INSERT INTO ai_model
(platform_code, platform_name, model_name, model_code, model_type, base_url, api_key,
 temperature, max_tokens, quota_total, usage_unit, expire_time, is_current, status, remark)
SELECT 'bailian', '阿里云百炼', 'Paraformer Realtime', 'paraformer-realtime-v2', 'asr',
       'https://dashscope.aliyuncs.com', '', 0.70, 2048, 10000, 'times',
       date_add(sysdate(), interval 30 day), 1, 1, '语音识别'
WHERE NOT EXISTS (SELECT 1 FROM ai_model WHERE platform_code = 'bailian' AND model_code = 'paraformer-realtime-v2' AND model_type = 'asr');

-- 存量库兼容：若某类型有启用模型但没有任何「当前模型」，自动选 id 最小的一条，
-- 避免运行时因历史数据缺少 is_current 标记而无法解析模型。
UPDATE ai_model
SET is_current = 1
WHERE id IN (
    SELECT keep_id FROM (
        SELECT MIN(id) AS keep_id
        FROM ai_model
        WHERE status = 1 AND deleted = 0
        GROUP BY model_type
        HAVING SUM(is_current = 1) = 0
    ) candidates
);
