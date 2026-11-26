/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : localhost:3306
 Source Schema         : cw-ai

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 26/11/2026 16:05:24
*/

USE `cw-ai`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_business_log
-- ----------------------------
DROP TABLE IF EXISTS `ai_business_log`;
CREATE TABLE `ai_business_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `session_id` bigint(0) NULL DEFAULT NULL COMMENT '会话ID ai_chat_session.id',
  `message_id` bigint(0) NULL DEFAULT NULL COMMENT '消息ID ai_chat_shturl.cc/',
  `user_id` bigint(0) NULL DEFAULT NULL COMMENT 'owner user id',
  `agent_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Agent名称：PlanAndExecuteAgent / ReActAgent / ReflectionAgent',
  `log_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志类型：plan / tool_call / reflection / dispatch',
  `log_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '日志详情',
  `cost_ms` bigint(0) NULL DEFAULT NULL COMMENT '耗时毫秒',
  `create_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_business_log_user_time`(`user_id`, `create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI Agent业务执行日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_business_log
-- ----------------------------
INSERT INTO `ai_business_log` VALUES (1, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":436,\"out\":35,\"ok\":true}', 1488, '2026-10-19 08:10:59');
INSERT INTO `ai_business_log` VALUES (2, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":552,\"out\":79,\"ok\":true}', 1278, '2026-10-19 08:11:01');
INSERT INTO `ai_business_log` VALUES (3, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"POST /api/fabric/defect/detect\"}', 2787, '2026-10-19 08:11:01');
INSERT INTO `ai_business_log` VALUES (4, NULL, NULL, NULL, '合规校验', 'api_call', '{\"status\":200,\"detail\":\"POST /api/compliance/check\"}', 7230, '2026-10-19 08:11:50');
INSERT INTO `ai_business_log` VALUES (5, NULL, NULL, NULL, '文本对话模型', 'model_call', '{\"model\":\"qwen-max\",\"in\":229,\"out\":500,\"ok\":true}', 10957, '2026-10-19 08:12:14');
INSERT INTO `ai_business_log` VALUES (6, NULL, NULL, NULL, '竞品调研', 'api_call', '{\"status\":200,\"detail\":\"GET /api/research/fabric\"}', 11194, '2026-10-19 08:12:14');
INSERT INTO `ai_business_log` VALUES (7, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 41, '2026-10-19 08:12:21');
INSERT INTO `ai_business_log` VALUES (8, NULL, NULL, NULL, '综合问答·多模态', 'model_call', '{\"model\":\"qwen3.8-flash\",\"in\":202097,\"out\":3482,\"ok\":true}', 71728, '2026-10-19 08:16:39');
INSERT INTO `ai_business_log` VALUES (9, NULL, NULL, NULL, '综合问答', 'api_call', '{\"status\":200,\"detail\":\"POST /api/ai/chat\"}', 6, '2026-10-19 08:16:39');
INSERT INTO `ai_business_log` VALUES (10, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 36, '2026-10-19 13:36:42');
INSERT INTO `ai_business_log` VALUES (11, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":436,\"out\":32,\"ok\":true}', 1301, '2026-10-19 13:36:54');
INSERT INTO `ai_business_log` VALUES (12, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":552,\"out\":79,\"ok\":true}', 1092, '2026-10-19 13:36:55');
INSERT INTO `ai_business_log` VALUES (13, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"POST /api/fabric/defect/detect\"}', 2406, '2026-10-19 13:36:55');
INSERT INTO `ai_business_log` VALUES (14, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":436,\"out\":32,\"ok\":true}', 756, '2026-10-19 13:37:28');
INSERT INTO `ai_business_log` VALUES (15, NULL, NULL, NULL, '面料疵点检测', 'model_call', '{\"model\":\"qwen3-omni-flash\",\"in\":552,\"out\":76,\"ok\":true}', 1278, '2026-10-19 13:37:29');
INSERT INTO `ai_business_log` VALUES (16, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"POST /api/fabric/defect/detect\"}', 2041, '2026-10-19 13:37:29');
INSERT INTO `ai_business_log` VALUES (17, NULL, NULL, NULL, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 10, '2026-10-19 21:53:52');
INSERT INTO `ai_business_log` VALUES (18, NULL, NULL, NULL, '语音识别', 'model_call', '{\"model\":\"paraformer-realtime-v2\",\"in\":null,\"out\":null,\"ok\":true}', 1182, '2026-10-19 21:56:26');
INSERT INTO `ai_business_log` VALUES (19, NULL, NULL, NULL, '语音识别', 'api_call', '{\"status\":200,\"detail\":\"POST /api/ai/asr\"}', 1193, '2026-10-19 21:56:26');
INSERT INTO `ai_business_log` VALUES (20, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 43, '2026-10-23 08:32:21');
INSERT INTO `ai_business_log` VALUES (21, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 11, '2026-10-23 08:32:24');
INSERT INTO `ai_business_log` VALUES (22, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 10, '2026-10-23 08:53:51');
INSERT INTO `ai_business_log` VALUES (23, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 8, '2026-10-23 08:53:56');
INSERT INTO `ai_business_log` VALUES (24, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 7, '2026-10-23 08:54:01');
INSERT INTO `ai_business_log` VALUES (25, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 12, '2026-10-23 10:53:53');
INSERT INTO `ai_business_log` VALUES (26, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 40, '2026-10-23 14:48:25');
INSERT INTO `ai_business_log` VALUES (27, 828376947, NULL, 1, '综合问答', 'api_call', '{\"status\":200,\"detail\":\"GET /api/ai/chat\"}', 51, '2026-10-24 15:52:59');
INSERT INTO `ai_business_log` VALUES (28, 828376947, NULL, 1, '综合问答', 'api_call', '{\"status\":200,\"detail\":\"GET /api/ai/chat\"}', 25, '2026-10-24 15:56:02');
INSERT INTO `ai_business_log` VALUES (29, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 82, '2026-11-02 16:03:23');
INSERT INTO `ai_business_log` VALUES (30, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 10, '2026-11-02 16:09:38');
INSERT INTO `ai_business_log` VALUES (31, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 15, '2026-11-02 16:09:50');
INSERT INTO `ai_business_log` VALUES (32, NULL, NULL, 1, '面料识别', 'api_call', '{\"status\":200,\"detail\":\"GET /api/erp/fabric/list\"}', 50, '2026-11-23 15:33:40');

-- ----------------------------
-- Table structure for ai_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_message`;
CREATE TABLE `ai_chat_message`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '消息主键',
  `session_id` bigint(0) NOT NULL COMMENT '关联ai_chat_session会话ID',
  `role` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息角色：user / assistant',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息文本内容',
  `multi_modal_data` json NULL COMMENT '多模态数据：图片、语音等元数据JSON',
  `tool_calls` json NULL COMMENT 'Agent工具调用记录JSON',
  `rag_retrieve_chunk` json NULL COMMENT '本次召回的RAG分片片段JSON，用于溯源',
  `token_input` int(0) NULL DEFAULT 0 COMMENT '输入token',
  `token_output` int(0) NULL DEFAULT 0 COMMENT '输出token',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '消息产生时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_session_id`(`session_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话消息明细表，保存每一轮user/assistant真实对话' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_message
-- ----------------------------
INSERT INTO `ai_chat_message` VALUES (1, 852941413, 'user', '', '[{\"size\": 188342, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"852941413/f67ffcf9-283d-4210-8f53-33d95bf5788d.png\"}]', NULL, NULL, 0, 0, '2026-10-13 10:37:19');
INSERT INTO `ai_chat_message` VALUES (2, 869722813, 'user', '', '[{\"size\": 167309, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"869722813/f80d694f-0e65-4e7a-9f03-f77b246613fd.png\"}]', NULL, NULL, 0, 0, '2026-10-13 13:35:23');
INSERT INTO `ai_chat_message` VALUES (3, 869722813, 'user', '', '[{\"size\": 167315, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"869722813/69e4647a-43b9-4a2e-a3f8-49b7d64eedd4.png\"}]', NULL, NULL, 0, 0, '2026-10-13 14:17:11');
INSERT INTO `ai_chat_message` VALUES (4, 879658126, 'user', '测试', '[{\"size\": 26274, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/dc498f0f-25ad-4607-add3-44d19080f037.png\"}]', NULL, NULL, 0, 0, '2026-10-13 16:20:59');
INSERT INTO `ai_chat_message` VALUES (5, 879658126, 'user', '', '[{\"size\": 32596, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/baec51e2-4955-4107-9d6c-dd023516e231.png\"}]', NULL, NULL, 0, 0, '2026-10-13 16:21:09');
INSERT INTO `ai_chat_message` VALUES (6, 879658126, 'user', '', '[{\"size\": 26274, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/28575f65-c2dd-4bd0-a10d-db676bd88fc0.png\"}]', NULL, NULL, 0, 0, '2026-10-13 16:37:52');
INSERT INTO `ai_chat_message` VALUES (7, 879658126, 'user', '', '[{\"size\": 993517, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/ca7fd096-d5a6-4507-91a9-4cb4371a4bc9.png\"}]', NULL, NULL, 0, 0, '2026-10-13 16:43:09');
INSERT INTO `ai_chat_message` VALUES (8, 879658126, 'user', '', '[{\"size\": 213752, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/dc9ecd7a-ae92-42b2-86cd-6871f3b7acf2.png\"}]', NULL, NULL, 0, 0, '2026-10-13 17:01:13');
INSERT INTO `ai_chat_message` VALUES (9, 879658126, 'user', '', '[{\"size\": 263267, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/6075409a-6287-461a-b32e-f1a3564b3409.png\"}]', NULL, NULL, 0, 0, '2026-10-13 17:05:22');
INSERT INTO `ai_chat_message` VALUES (10, 879658126, 'user', '', '[{\"size\": 263267, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/cf0cf9fa-5c88-4399-aa62-923e88f35e43.png\"}]', NULL, NULL, 0, 0, '2026-10-13 17:06:50');
INSERT INTO `ai_chat_message` VALUES (11, 879658126, 'user', '', '[{\"size\": 1015555, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/da30f9ae-5505-4d9a-83f1-fcfc4359b44f.png\"}]', NULL, NULL, 0, 0, '2026-10-13 17:15:01');
INSERT INTO `ai_chat_message` VALUES (12, 879658126, 'user', '', '[{\"size\": 786464, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/1a82cef4-f93b-4aff-8cf8-4ebd85e31c59.png\"}]', NULL, NULL, 0, 0, '2026-10-14 08:53:13');
INSERT INTO `ai_chat_message` VALUES (13, 879658126, 'user', '', '[{\"size\": 786464, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/29c5bb67-723c-4976-bc95-8abcafb60e76.png\"}]', NULL, NULL, 0, 0, '2026-10-14 09:36:51');
INSERT INTO `ai_chat_message` VALUES (14, 879658126, 'user', '', '[{\"size\": 162918, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/bad6ae50-02fa-4cbc-ab38-f408114da61c.png\"}]', NULL, NULL, 0, 0, '2026-10-14 15:30:58');
INSERT INTO `ai_chat_message` VALUES (15, 879658126, 'user', '', '[{\"size\": 755228, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/53ec5eb9-9b82-4675-8558-62acfd7eae46.png\"}]', NULL, NULL, 0, 0, '2026-10-14 15:34:31');
INSERT INTO `ai_chat_message` VALUES (16, 879658126, 'user', '这个是官网调用多模型的案例，但是要我写我写不出来怎么办？', '[{\"size\": 395280, \"type\": \"image\", \"fileName\": \"image.png\", \"mimeType\": \"image/png\", \"objectName\": \"879658126/2c575809-40c3-4740-83c5-a34300881f86.png\"}]', NULL, NULL, 0, 0, '2026-10-14 15:42:58');
INSERT INTO `ai_chat_message` VALUES (17, 968994020, 'user', '测试', '[{\"size\": 2271020, \"type\": \"file\", \"fileName\": \"c5e9602a76407f4c3249829247df0554.pdf\", \"mimeType\": \"application/pdf\", \"objectName\": \"968994020/ca497134-7d9b-4b08-9ccb-65edae1ce284.pdf\"}]', NULL, NULL, 0, 0, '2026-10-14 17:09:55');
INSERT INTO `ai_chat_message` VALUES (18, 23270192, 'user', '', NULL, NULL, NULL, 0, 0, '2026-10-15 08:14:31');
INSERT INTO `ai_chat_message` VALUES (19, 23270192, 'assistant', '# 《中国纺织服装行业合规建设基线研究报告》分析与解读\n\n## 一、报告定位：一份“诊断型”而非“达标型”研究\n\n这份报告由中国纺织工业联合会社会责任办公室受**工业和信息化部产业政策与法规司委托**，于2023年6月启动、11月发布。其性质是“**基线调研**”（baseline）——即在行业合规建设尚未全面铺开时，先摸清“现状、经验、困难、需求”，为后续政策与服务提供参照系。\n\n- **样本**：77家企业，问卷+深度访谈结合；企业规模按“三分位法”划分（<500人小型、500–2000人中型、≥2000人大型）。\n- **方法局限（报告自陈）**：数据主要来自问卷，存在填报偏差；访谈企业数远小于样本量，代表性可能不足。\n\n> **解读**：正因为是“基线”，报告的价值不在于精确测量，而在于**建立坐标、暴露结构性差异**。下文所有百分比都应放在“小样本、自报数据”的背景下理解，重趋势、轻点值。\n\n---\n\n## 二、企业画像：样本本身决定了合规水平的“底色”\n\n| 维度 | 关键数据 | 对合规的含义 |\n|---|---|---|\n| 企业属性 | 内资民企83.12%、港澳台7.79%、国企/国有控股6.49%、外商独资2.6% | 行业主体是**缺乏外部合规传统与政策强制**的民企，合规更多靠“自发” |\n| 上市情况 | 上市仅19.48%，其中86.67%在内地 | 受资本市场/域外规则约束的“强合规驱动”企业是少数 |\n| 规模 | 小/中/大=31/25/21家 | 中小占多数，**资源约束**是普遍现实 |\n| 行业 | 棉纺36.6%、服装服饰28.57%、针织22.08%、印染20.78%、产业用18.18% | 产业链长、环节多，风险点分散 |\n\n> **解释**：画像揭示了一个根本矛盾——**合规的“压力源”与企业的“主体构成”错位**。序言指出行业“深度融入国际价值链，国际标准日益严格”，但样本里真正承受域外合规压力的上市/外资/大型企业占比很低。这为后文“认知高、落地弱”埋下伏笔。\n\n---\n\n## 三、核心发现与逐层解读\n\n### 发现1：合规“认知准确”，但“激励认知严重不足”——最关键的落差\n- 83.12%的企业能准确定义合规（“为防控风险、提升经营水平的规范管理活动”）；超九成认可合规对品牌、竞标、信誉的价值。\n- **但**：仅不到两成认识到刑事激励（合规可作无罪/免责依据），22%认识到行政激励（协商避免处罚），37%认识到可免于境外制裁；上市公司在这三项上（均40%）明显高于非上市（12.9%、17.74%）。\n\n> **解读**：企业把合规当作“**管理工具/成本项**”，而非“**风险对冲/免责机制**”。而合规制度最核心的功能恰恰是“激励”——建立有效体系可在涉罪/涉罚时争取宽大。激励被低估，直接削弱企业投入意愿，是“想合规但不愿真投入”的心理根源。报告用“行政和解”“合规不起诉”两个知识链接补足这一认知缺口，意图明显。\n\n### 发现2：专项合规普及率（72.73%）高于总体合规（51.95%）——“务实优先”\n- 总体制度：51.95%已制定，28.57%在制定，19.48%短期无打算。\n- 专项制度：72.73%已在某一领域制定。\n- 专项热点：**劳动用工/安全生产94.81%、财税84.42%**，其次环保58.44%、知产55.84%、数据54.55%、反商业贿赂48.05%。\n\n> **解释**：报告自己点出原因——专项制度“针对性、灵活性、资源节约”。在缺钱缺人的约束下，企业选择**先做“看得见、罚得起不起”的高频风险**，而非搭“全面体系”。这既是理性，也带来隐患：没有总体框架，专项之间易割裂、难协同。行业特异性也在此显现：印染重环保（75%）、服装重反商业贿赂（50%）、棉纺重数据安全——**合规重点跟着行业风险地图走**。\n\n### 发现3：搭建主体“以自建为主”，专业外援不足\n- 48.05%“主要由企业自行搭建”，37.66%“与第三方共同搭建”。\n- 分化明显：外商独资100%、港澳台50%、上市公司60%倾向与第三方合作；内资民企超半数自行搭建。\n\n> **解读**：自建反映“自我规范”意识，但也印证报告担忧的“**缺乏外部专业指导**”。外资/上市更愿买专业服务，民企更“自力更生”——这与民企预算紧、对合规价值认知浅相关，可能导致自建体系质量参差。\n\n### 发现4：合规负责人“高层挂帅”，但机构“缺位+繁杂”\n- 最高负责人：董事长68.83%、总经理/执行董事53.25%；**规模越大、级别越高**（大型81%为董事长）。\n- 机构：仅22.08%设专门合规部门，44.16%由法务/财务/审计/HR兼管，23.38%未设；小型企业设专门机构不到10%。\n\n> **解释**：这里有一个**“重视姿态”与“落地能力”的背离**——高层挂帅说明“政治正确”到位，但缺少独立牵头部门意味着**权责不清、日常无人扛**。报告用《跨境指引》的“决策—管理—执行”三层架构对照，正是要指出：光有董事长签字不够，必须建立“合规牵头部门+业务归口执行”的治理结构，否则体系空转。\n\n### 发现5：监督“神经末梢”偏弱\n- 合规联络员：53.25%已设，针织仅35.29%、小型仅15%。\n- 举报途径：63.64%已设（国企100%、非上市不足四成）；举报激励：50.65%已设。\n\n> **解读**：联络员和举报是合规体系的“**预警神经**”。设置率低（尤其民企、小企业）意味着违规发现依赖事后而非事前；激励不足则导致“不敢报、不愿报”，监督形同虚设。报告强调“保护举报人不被报复”，切中要害。\n\n### 发现6：成效——境内“太平”，境外“承压”\n- 自2021年以来，境内被行政处罚/刑事处罚的仅2家（广告、税务）。\n- 但**12.99%的企业因境外合规要求导致业务量减少**。\n\n> **解释**：这是全报告最具“行业现实感”的一组对照。它说明中国纺织服装企业的合规压力**主要不是来自境内执法，而是来自国际价值链**（ESG、供应链尽调、制裁、客户审核）。境内宽松+境外收紧，恰好解释了为什么“外压型”企业（上市、出口导向、外资）合规水平更高——**谁挨客户的刀，谁就先建盾**。\n\n### 发现7：困难—需求—建议的“逻辑闭环”\n- 内部最大困难：**缺人才63.64%**、成本高35.06%、员工意识难教31.17%；非上市企业人才缺口更突出（67.74%）。\n- 外部最大挑战：业务变化带来新需求58.44%、各国法规差异50.65%、标准不清晰44.16%。\n- 最需要的支持：**明确合规标准77.92%**、法规政策指导63.64%、合规教育53.25%。\n- 最迫切提升领域：劳动用工/安全58.44%、财税57.14%、数据55.84%。\n\n> **解读**：报告把“困难—需求—建议”串成一条因果链：企业不是不想合规，而是**缺标准、缺人、缺钱、缺外部确定性**。因此第六章的五条建议（出台行业标准、加强培训、试点先行、信息化、产业链协同）并非泛泛而谈，而是**逐条对症**——标准对应“缺标准”，培训对应“缺人才/意识”，试点对应“不知怎么建”，信息化对应“成本高/流程乱”，产业链协同对应“外压传导”。这是报告政策设计上的亮点。\n\n---\n\n## 四、专项领域章节：把抽象合规“翻译”成行业场景\n\n第五章是报告的**实操价值所在**，它不重复数据，而是给出纺织服装行业的“合规风险地图”：\n\n- **劳动用工**：女职工“三期”与性骚扰（行业女性员工多）、加班上限与举证、平台用工/事实劳动关系（网络主播案例）、混同与轮换用工（集团化、社保缴纳主体错位）。\n- **安全生产**：双重预防机制（风险分级管控+隐患排查）、全员责任制“一岗双责”、公益诉讼与强制执行风险。\n- **知识产权**：商标（贴牌/剪标/“驰名商标”字样违规）、专利（外观设计与服装“先公开后申请”的矛盾）、著作权（成衣能否作“美术作品”保护、云创诉卡诗兰案）。\n- **数据与信息安全**：《数据安全法》全流程义务、《个保法》举证责任倒置、滴滴案警示、个人信息“收集—储存—使用—委托”合规清单。\n\n> **解释**：这一章的意义在于**降低企业“不知从何下手”的门槛**。它告诉企业：合规不是空喊口号，而是“招聘别问婚育”“加班别超36小时”“别乱标驰名商标”“处理消费者数据要授权+加密”。这是基线报告从“诊断”走向“开方”的桥梁。\n\n---\n\n## 五、贯穿全文的“分水岭变量”\n\n把所有章节叠在一起看，报告其实反复验证了同一组**解释变量**——它们几乎在每个指标上都拉开差距：\n\n| 分水岭 | 合规水平更高的一方 | 驱动机制 |\n|---|---|---|\n| 上市 vs 非上市 | 上市 | 资本市场披露+域外规则+客户审核 |\n| 大型 vs 小型 | 大型 | 资源+治理结构+被关注度高 |\n| 国企/外资/港澳台 vs 内资民企 | 前三者 | 政策强制（央企办法）/起步早的域外合规传统 |\n| 出口导向/融入价值链 vs 纯内销 | 前者 | 境外合规压力（见成效部分） |\n\n> **核心解释**：中国纺织服装行业的合规水平，本质是“**外部压力大小**”的函数，而非“内部觉悟”的函数。谁承受更强的制度性、市场性外部压力，谁的合规体系就更完善。这恰恰解释了为什么报告把“出台行业标准、加强培训、产业链协同”作为建议——**目的是给缺乏外部压力的内资民企“人造”一套确定性与驱动力**。\n\n---\n\n## 六、方法论评价\n\n**优点**：\n1. 诚实标注局限（问卷偏差、访谈代表性），符合“基线”定位。\n2. 多维度交叉（规模×上市×性质×行业），避免单一结论。\n3. 数据—法理—案例—建议四层结合，可读性与专业性兼顾。\n\n**需注意**：\n1. 77家样本下，部分子群体（如外商独资仅2.6%≈2家、某些行业细分）百分比波动大，**不宜过度解读点值**。\n2. 自报数据可能高估“已制定制度”的比例（填了问卷≠制度有效运行），报告未做有效性验证——这也正是其建议中“开展合规体系有效性评价研究”要补的课。\n3. 报告是“应然+实然”混合体：现状描述与价值倡导（如“设立专门部门是必要的”）有时交织，阅读时需区分。\n\n---\n\n## 七、总体判断\n\n> 一句话定性：**中国纺织服装行业合规建设处于“认知已立、体系未成、激励未明、外压先行、内困突出”的过渡基线阶段。**\n\n具体表现为四组张力：\n1. **认知与激励的张力**——懂合规是什么，不懂合规能“救”企业。\n2. **专项与总体的张力**——会“点状”防火，缺“系统”治理。\n3. **重视与落地的张力**——高层挂帅，但独立机构与人才跟不上。\n4. **内松与外紧的张力**——境内执法宽松，国际价值链才是真考场。\n\n报告的结论与建议，正是针对这四组张力开出的药方：**用标准补确定性、用培训补人才、用试点补路径、用信息化补效率、用产业链协同补外压传导**。其最终指向，是把行业从“被动应付客户审核”的合规1.0，推向“主动构建免责与竞争力”的合规2.0。\n\n---\n\n如你需要，我可以进一步聚焦某一章（例如把“劳动用工合规”做成可直接落地的企业自查清单，或把“困难—需求—建议”整理成政策备忘录格式），告诉我方向即可。', NULL, NULL, NULL, 0, 0, '2026-10-15 08:16:21');
INSERT INTO `ai_chat_message` VALUES (20, 43034748, 'user', 'GB 18401-2010 对纺织品安全类别是如何划分的？', NULL, NULL, NULL, 0, 0, '2026-10-15 13:43:57');
INSERT INTO `ai_chat_message` VALUES (21, 43034748, 'assistant', 'GB 18401-2010 是中国国家纺织产品基本安全技术规范，它根据纺织品的最终用途和与人体皮肤接触的程度来划分安全类别。该标准将纺织品分为以下三类：\n\n1. **A类（婴幼儿用品）**：\n   - 适用于36个月及以下婴幼儿使用的纺织产品。\n   - 对甲醛含量、pH值、染色牢度、异味、可分解致癌芳香胺染料等有最严格的要求。\n\n2. **B类（直接接触皮肤的产品）**：\n   - 适用于成人穿着的内衣、床单、被套等直接接触皮肤的纺织品。\n   - 相对于A类要求稍宽松一些，但对甲醛含量、pH值、染色牢度等也有严格的规定。\n\n3. **C类（非直接接触皮肤的产品）**：\n   - 适用于外套、窗帘、地毯等不直接接触皮肤的纺织品。\n   - 对于甲醛含量、pH值等的要求相对宽松，但仍需符合一定的安全标准。\n\n每个类别都有具体的指标限制，比如甲醛含量（mg/kg）、pH值范围、耐水色牢度、耐汗渍色牢度、耐干摩擦色牢度以及是否含有可分解致癌芳香胺染料等。生产企业需要确保其产品满足相应类别的所有要求，并通过相关检测以保证产品的安全性。\n\n如果您需要针对某一特定产品了解更详细的合规性要求，可以提供更多信息，我能够进一步指导如何进行相关的测试或提供其他建议。此外，如果涉及到出口业务，您可能还需要考虑目标市场的具体法规要求，因为不同国家和地区可能会有不同的安全标准。', NULL, NULL, NULL, 0, 0, '2026-10-15 13:44:06');
INSERT INTO `ai_chat_message` VALUES (22, 43065287, 'user', '如何鉴别纯棉和涤棉混纺面料？', NULL, NULL, NULL, 0, 0, '2026-10-15 13:44:25');
INSERT INTO `ai_chat_message` VALUES (23, 43065287, 'assistant', '鉴别纯棉和涤棉混纺面料主要可以通过以下几个方法来进行：\n\n1. **手感**：\n   - 纯棉面料通常手感柔软，透气性好，且有一定的厚度。\n   - 涤棉混纺面料由于含有合成纤维，可能会感觉稍微硬一些，并且在触感上可能不如纯棉那么自然。\n\n2. **燃烧测试**：\n   - 从布料边缘取一小块样品进行燃烧。纯棉燃烧时会有纸张燃烧的气味，火焰为黄色，离开火源后会继续燃烧并留下灰色或白色的灰烬。\n   - 涤纶（聚酯）燃烧时有刺鼻的气味，类似于塑料燃烧的味道，火焰为亮黄色，燃烧时会熔化成滴状物，冷却后形成坚硬的黑色小球。\n\n3. **吸水性测试**：\n   - 将几滴水滴在面料表面，观察吸收情况。纯棉面料具有良好的吸湿性，水滴会被快速吸收。\n   - 涤棉混纺面料因为含有不易吸水的涤纶成分，所以吸水速度较慢，有时水滴会在表面停留一段时间。\n\n4. **显微镜检查**：\n   - 使用显微镜观察纤维形态。棉纤维在显微镜下呈现天然植物纤维特有的扁平带状结构，而涤纶纤维则呈现出光滑、均匀的圆形或椭圆形截面。\n\n5. **化学试剂测试**：\n   - 使用特定的化学试剂可以区分不同类型的纤维。例如，使用浓硫酸可以溶解棉纤维而不溶解涤纶纤维；或者使用70%的硫酸，棉纤维不会溶解而涤纶纤维会溶解。\n\n6. **标签信息**：\n   - 如果是成品衣物，可以直接查看产品标签上的成分说明。正规厂家生产的纺织品都会明确标示其材质构成。\n\n请注意，在进行上述测试时，尤其是燃烧测试，要确保安全，避免火灾风险。同时，对于贵重的面料，建议先咨询专业人士或使用非破坏性的方法来辨别。\n\n如果您需要进一步的帮助，比如通过图片识别面料类型，请提供相关图片，我可以尝试帮助您分析。另外，我们还可以利用智能面料识别功能来更准确地确定面料的具体成分。', NULL, NULL, NULL, 0, 0, '2026-10-15 13:44:40');
INSERT INTO `ai_chat_message` VALUES (24, 43065287, 'user', '测试', NULL, NULL, NULL, 0, 0, '2026-10-15 14:02:31');
INSERT INTO `ai_chat_message` VALUES (25, 43065287, 'assistant', '您好！看起来您想进行某种测试，但信息似乎不完整。如果您是想对纺织面料进行测试，比如鉴别纯棉和涤棉混纺面料，或者有其他关于纺织品的具体问题，请提供更多的细节或明确您的需求。这样我才能更好地为您提供帮助。\n\n如果您需要了解如何具体操作上述提到的任何一种鉴别方法，或是有关于纺织品外贸、生产制造等方面的其他问题，也请随时告诉我！\n\n如果您的“测试”是指其他方面的内容，请补充说明，我会尽力给出合适的建议。期待您的回复！', NULL, NULL, NULL, 0, 0, '2026-10-15 14:02:31');
INSERT INTO `ai_chat_message` VALUES (26, 43065287, 'user', '测试', NULL, NULL, NULL, 0, 0, '2026-10-15 14:06:27');
INSERT INTO `ai_chat_message` VALUES (27, 43065287, 'assistant', '您好！您提到“测试”，但没有提供具体的信息或背景。为了更好地帮助您，请您详细说明一下想要进行哪方面的测试，或者您遇到的具体问题是什么？比如：\n\n- 您是想了解如何鉴别不同类型的面料吗？\n- 您需要关于纺织品质量检测的方法吗？\n- 您有关于纺织品外贸、生产制造或其他相关领域的问题吗？\n\n请提供更多细节，这样我才能更准确地为您提供帮助。期待您的回复！', NULL, NULL, NULL, 0, 0, '2026-10-15 14:06:27');
INSERT INTO `ai_chat_message` VALUES (28, 44708173, 'user', '如何鉴别纯棉和涤棉混纺面料？', NULL, NULL, NULL, 0, 0, '2026-10-15 14:15:20');
INSERT INTO `ai_chat_message` VALUES (29, 44708173, 'assistant', '鉴别纯棉和涤棉混纺面料可以通过多种方法来进行，包括手感、燃烧测试、吸水性测试以及借助专业设备进行检测。下面是一些简单实用的方法：\n\n1. **手感与外观**:\n   - **纯棉面料**通常触感柔软，透气性好，且具有自然的光泽。\n   - **涤棉混纺面料**（聚酯纤维与棉混纺）则相对硬挺一些，因为加入了合成纤维的缘故，可能会感觉稍微滑一些，光泽度也比纯棉要高。\n\n2. **燃烧测试** (请在安全环境下操作)：\n   - 从待测面料上取一小块样本。\n   - 使用打火机或火柴点燃样品边缘。\n     - **纯棉**：火焰呈黄色，燃烧时有纸张燃烧的味道；离开火源后继续燃烧，灰烬为细软粉末状。\n     - **涤纶**：接近火焰时会收缩并熔化成珠滴落，燃烧时发出黑烟，并带有刺激性气味；离开火源后立即熄灭，形成硬而脆的黑色球形残留物。\n   - 对于**涤棉混纺**，你会观察到上述两种现象同时存在，即部分迅速熔化滴落，另一部分像棉一样持续燃烧但速度较慢，燃烧后的残留物部分易碎部分不易碎。\n\n3. **吸水性实验**:\n   - 纯棉由于其天然纤维结构，具有良好的吸湿性能。\n   - 将几滴水滴在面料表面，观察吸收情况。如果水被快速吸收，则可能是纯棉；若水珠停留于表面不被吸收或仅缓慢渗透，则很可能是含有较多涤纶成分的混纺织物。\n\n4. **使用化学试剂** (适用于实验室条件下):\n   - 可以通过特定化学试剂来区分不同类型的纤维，但这需要一定的专业知识及安全措施。\n\n5. **专业仪器检测**:\n   - 利用显微镜观察纤维形态、采用红外光谱仪分析等科学手段可以准确地识别出面料的具体组成成分比例，这种方法更为精确但也更复杂。\n\n请注意，在实际应用中，尤其是对于成品服装而言，最可靠的方式还是查看产品标签上的成分说明。此外，如果您是从事纺织品贸易的专业人士，建议定期参加相关培训课程或研讨会，以便掌握最新的检测技术和行业动态。希望这些建议对您有所帮助！如果有其他具体问题或者需要进一步的帮助，请随时告诉我。', NULL, NULL, NULL, 0, 0, '2026-10-15 14:15:20');
INSERT INTO `ai_chat_message` VALUES (30, 368927181, 'user', '解析里面的内容', NULL, NULL, NULL, 0, 0, '2026-10-19 08:15:27');
INSERT INTO `ai_chat_message` VALUES (31, 368927181, 'assistant', '# 《中国纺织服装行业合规建设基线研究报告》内容解析\n\n## 一、报告定位与方法\n\n- **发布方**：中国纺织工业联合会社会责任办公室，受**工业和信息化部产业政策与法规司**委托编制，2023年11月发布。\n- **目的**：全面梳理纺织服装行业企业合规建设现状，总结经验、发现困难、识别需求，为提升行业合规能力打基础。\n- **方法**：问卷调研 + 深度访谈，**样本企业 77 家**（问卷共31题，半记名）。\n- **自承局限**：主要数据来自问卷，企业填写可能有偏差；深度访谈企业数远小于样本量，代表性可能不足。\n\n## 二、企业画像（样本结构）\n\n| 维度 | 关键分布 |\n|---|---|\n| 企业属性 | 内资民企 **83.12%**、港澳台 7.79%、国企/国有控股 6.49%、外商独资 2.6% |\n| 上市情况 | 上市 **19.48%**（其中内地 86.67%），非上市 80.52% |\n| 企业规模 | 大型 21 家、中型 25 家、小型 31 家（按雇佣人数 <500 / 500–2000 / ≥2000 三分位划分） |\n| 所在行业 | 棉纺织 36.6%、服装服饰 28.57%、针织 22.08%、印染 20.78%、产业用纺织品 18.18%（部分企业跨多行业） |\n\n## 三、合规体系建设情况（核心发现）\n\n**1. 认知层面**\n- 83.12% 企业能准确理解合规内涵；超八成认可合规可赢得竞标、超九成认可其塑造品牌信誉的价值。\n- **短板**：对\"违规涉罪后合规的激励作用\"认识不足——仅约 22% 意识到行政激励、37% 意识到可免于境外制裁，刑事激励认知更低；但上市公司认知明显高于非上市公司。\n\n**2. 制度搭建**\n- 总体合规制度：已制定 **51.95%**，正在/准备制定 28.57%，短期无打算 19.48%。\n- 专项合规制度：已制定 **72.73%**，普及率高于总体制度（因专项更具针对性、灵活、省资源）。\n- 专项领域侧重：**劳动用工和安全生产 94.81%**、财税 84.42%、环保 58.44%、知识产权 55.84%、数据与信息安全 54.55%、反腐败/反商业贿赂 48.05%。\n- 搭建主体：自行搭建 48.05%、企业与第三方共同 37.66%、纯第三方 10.39%；**上市公司、外商独资更倾向引入第三方**，一般企业偏自主搭建。\n\n**3. 组织与人员**\n- 合规最高负责人：董事长 68.83%、总经理/执行董事 53.25%；**规模越大、级别越高**（大型企业 81% 由董事长负责）。\n- 合规管理机构：设专门部门仅 **22.08%**，设合规专员 10.39%，由法务/财务/审计/HR 等兼管 44.16%，**尚未设立 23.38%**——专门机构缺位是普遍问题。\n- 合规联络员：设立 53.25%，未设立 48.86%；小企业仅 15% 设立。\n\n**4. 监督机制**\n- 合规举报途径：设立 63.64%，未设 32.47%。\n- 举报激励制度：设立 50.65%，未设 42.86%。\n- 规律：**上市 > 非上市、国企 > 民企、大规模 > 小规模**，差异显著。\n\n## 四、合规风险防范措施\n\n- **合规审计**：定期 51.95%、不定期 32.47%、从未 11.69%；国企全部定期，上市公司执行更规范。\n- **合规风险评估**：开展者超 80%，但**仅 32.47% 定期**；评估最关注财税（92.06%）、劳动用工安全（88.89%）、环保（60.32%）、数据信息安全（55.56%）。\n- **合规尽职调查**：涉及投资的企业中约**七成**做投前专门合规尽调；最关注劳动用工安全（90%）。\n- **第三方合规管理**：仅 **48.05%** 在合作中开展，重视度待加强（上市 73.33% vs 非上市 41.94%）。\n- **合规文化**：开展建设 54.55%；编写合规手册 35.06%（其中公布 27.27%+7.79%）。\n- **合规培训**：开展 81.81%，但定期仅 35.06%；内容集中于劳动用工安全（92.06%）、财税（77.78%）。\n\n## 五、建设成效与困难挑战\n\n**成效**：自2021年以来，仅 **12.99%** 企业因境外合规要求业务减少；遭受境内行政/刑事处罚的仅 **2 家**（广告、税务领域），整体执法风险较低。\n\n**内部困难**（多选）：缺乏专业人才 **63.64%**、监督审查成本高 35.06%、员工意识教育难 31.17%、原有制度难突破 22.08%、管理层意识淡薄 24.68%、财力人力不足 3.90%。非上市企业人才缺口尤其突出（67.74%）。\n\n**外部挑战**：业务变化带来新合规需求 58.44%、不同国家/地区法规差异 50.65%、**标准不清晰 44.16%**、监管环境变化 42.86%。\n\n**最需要的支持**：明确的合规体系建设标准 **77.92%**、法律法规政策指导 63.64%、合规意识与风险教育 53.25%、专项能力提升 49.35%。\n\n**最迫切提升领域**：劳动用工安全 58.44%、财税 57.14%、数据与信息安全 55.84%。\n\n## 六、专项合规领域要点（法律指引）\n\n1. **劳动用工**：女职工\"三期\"保护与就业歧视（《妇女权益保障法》2023施行，违者罚1–5万）、加班时长与报酬（每月≤36小时，超时受罚）、平台用工事实劳动关系认定（附网络主播案）、混同/轮换用工的社保与合同风险。\n2. **安全生产**：民事/刑事/行政三重责任；\"风险分级管控+隐患排查治理\"双重预防机制；新《安全生产法》确立\"全员安全生产责任制\"\"一岗双责\"。\n3. **知识产权**：商标（贴牌剪标侵权、禁用\"驰名商标\"字样否则罚10万）、专利（外观设计保护与服装\"先公开后申请\"困境）、著作权（成衣作为实用艺术/美术作品受保护，附波点连衣裙侵权案，建议留存原稿、做权属登记）。\n4. **数据与信息安全**：以《网络安全法》《数据安全法》《个人信息保护法》为基石；引用**滴滴被罚80.26亿元**案例警示；《个保法》举证责任倒置；处理超100万人信息者每年须合规审计。报告附\"收集—储存—使用—委托/共享\"各环节合规要点表。\n\n## 七、结论与建议（五条）\n\n1. **加速出台行业合规体系建设标准**，并建立信用评价与奖惩机制。\n2. **加强行业合规培训**，开展差异化、定制化培训，提升企业能力与企业自律。\n3. **开展行业合规建设试点**，针对反商业贿赂、知识产权、环境、用工等领域选树典型并推广，建立有效性评价体系。\n4. **促进信息技术应用**，建设数字化合规管理平台与行业合规数据库。\n5. **强化产业链合作与沟通**，将合规融入供应链尽责管理，上下游信息互通。\n\n---\n\n### 一句话总判断\n该基线报告显示：中国纺织服装企业**合规\"认知\"和\"专项制度\"普及率已较高，但\"专门机构、定期评估、第三方管理、激励制度\"等深度建设仍明显不足**；企业最缺的是**人才与清晰标准**，最需的是**官方出台行业合规建设标准与实操指引**——这正是报告提出五条政策建议的现实依据。', NULL, NULL, NULL, 0, 0, '2026-10-19 08:16:39');
INSERT INTO `ai_chat_message` VALUES (32, 828376947, 'user', '双绉是什么？', NULL, NULL, NULL, 0, 0, '2026-10-24 15:52:57');
INSERT INTO `ai_chat_message` VALUES (33, 828376947, 'user', '双绉是什么？', NULL, NULL, NULL, 0, 0, '2026-10-24 15:55:52');
INSERT INTO `ai_chat_message` VALUES (34, 828376947, 'assistant', '您好！关于\"双绉\"，这正是我的专业主场——纺织面料领域的问题。\n\n**双绉（Crepe de Chine）** 是一种经典的丝织物，我来为您详细解析：\n\n## 一、基本定义\n双绉是一种**平纹组织的薄型丝织物**，属于绉类丝绸。它的特点是通过**经纬线捻度及捻向的配合**，使织物表面产生绉缩效应，形成细密均匀的绉纹。\n\n## 二、关键工艺特征\n1. **原料**：通常采用**桑蚕丝**（也可用人造丝、涤纶丝替代降低成本）\n2. **组织**：平纹组织为基础\n3. **捻度工艺**（核心）：\n   - 纬线采用**强捻丝**（捻度较高）\n   - 且**两根左捻、两根右捻**（或Z捻与S捻）交替排列织入\n   - 经炼染后，纬向的左右捻丝因内应力平衡产生**波浪状绉缩**，形成满布表面的细密皱纹\n4. **\"双绉\"之名的由来**：因纬线以\"两根S捻+两根Z捻\"交替织入，故称\"**双**绉\"（区别于捻向变化更复杂的\"四绉\"等）。\n\n## 三、外观与手感\n- 表面呈现**均匀细密的绉纹**，质地轻柔、富有弹性\n- 手感**爽滑、悬垂性好**，有柔和的亚光泽\n- 穿着透气、不贴身，夏天尤为舒适\n\n## 四、常见用途\n- 男女衬衫、连衣裙、旗袍、晚礼服\n- 丝巾、内衣、衬里等\n\n## 五、外贸实务提示\n在纺织品外贸中，双绉常以具体规格询价，如：\n- **克重**：常见的如 12姆米、14姆米、16姆米（m/m）等，姆米数越高越厚重\n- **幅宽**：如 114cm、140cm 等\n- **原料比例**：100%桑蚕丝，或 锦纶/涤纶混纺等\n\n如果您在做双绉的外贸订单，**建议使用我的智能报价功能**——输入原料、克重、幅宽、加工工艺（染色/印花），可以快速核算成本与FOB报价参考。同时也可用**面料识别**功能确认来样的真丝成分比例。\n\n请问您是想采购、生产双绉面料，还是需要针对具体规格做报价或调研呢？我可以进一步帮您。😊', NULL, NULL, NULL, 0, 0, '2026-10-24 15:56:02');

-- ----------------------------
-- Table structure for ai_chat_message_attachment
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_message_attachment`;
CREATE TABLE `ai_chat_message_attachment`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '附件主键',
  `message_id` bigint(0) NOT NULL COMMENT '消息ID ai_chat_message.id',
  `session_id` bigint(0) NOT NULL COMMENT '会话ID ai_chat_session.id（同时作为MinIO文件夹名）',
  `attach_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '附件类型：image=图片 file=文档附件',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始文件名',
  `file_ext` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件扩展名（不含点，如 jpg、pdf）',
  `mime_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'MIME类型，如 image/jpeg',
  `file_size` bigint(0) NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `bucket_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'cw-ai' COMMENT 'MinIO bucket名',
  `object_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MinIO对象名（含会话ID文件夹，如 12/uuid.jpg）',
  `sort_no` int(0) NOT NULL DEFAULT 0 COMMENT '同消息内展示顺序（上传顺序）',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chat_attach_message`(`message_id`) USING BTREE,
  INDEX `idx_chat_attach_session`(`session_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI聊天消息附件表（综合问答图片/文档的MinIO对象存储记录）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_message_attachment
-- ----------------------------
INSERT INTO `ai_chat_message_attachment` VALUES (1, 1, 852941413, 'image', 'image.png', 'png', 'image/png', 188342, 'cw-ai', '852941413/f67ffcf9-283d-4210-8f53-33d95bf5788d.png', 0, '2026-10-13 10:37:19');
INSERT INTO `ai_chat_message_attachment` VALUES (2, 2, 869722813, 'image', 'image.png', 'png', 'image/png', 167309, 'cw-ai', '869722813/f80d694f-0e65-4e7a-9f03-f77b246613fd.png', 0, '2026-10-13 13:35:23');
INSERT INTO `ai_chat_message_attachment` VALUES (3, 3, 869722813, 'image', 'image.png', 'png', 'image/png', 167315, 'cw-ai', '869722813/69e4647a-43b9-4a2e-a3f8-49b7d64eedd4.png', 0, '2026-10-13 14:17:11');
INSERT INTO `ai_chat_message_attachment` VALUES (4, 4, 879658126, 'image', 'image.png', 'png', 'image/png', 26274, 'cw-ai', '879658126/dc498f0f-25ad-4607-add3-44d19080f037.png', 0, '2026-10-13 16:20:59');
INSERT INTO `ai_chat_message_attachment` VALUES (5, 5, 879658126, 'image', 'image.png', 'png', 'image/png', 32596, 'cw-ai', '879658126/baec51e2-4955-4107-9d6c-dd023516e231.png', 0, '2026-10-13 16:21:09');
INSERT INTO `ai_chat_message_attachment` VALUES (6, 6, 879658126, 'image', 'image.png', 'png', 'image/png', 26274, 'cw-ai', '879658126/28575f65-c2dd-4bd0-a10d-db676bd88fc0.png', 0, '2026-10-13 16:37:52');
INSERT INTO `ai_chat_message_attachment` VALUES (7, 7, 879658126, 'image', 'image.png', 'png', 'image/png', 993517, 'cw-ai', '879658126/ca7fd096-d5a6-4507-91a9-4cb4371a4bc9.png', 0, '2026-10-13 16:43:09');
INSERT INTO `ai_chat_message_attachment` VALUES (8, 8, 879658126, 'image', 'image.png', 'png', 'image/png', 213752, 'cw-ai', '879658126/dc9ecd7a-ae92-42b2-86cd-6871f3b7acf2.png', 0, '2026-10-13 17:01:13');
INSERT INTO `ai_chat_message_attachment` VALUES (9, 9, 879658126, 'image', 'image.png', 'png', 'image/png', 263267, 'cw-ai', '879658126/6075409a-6287-461a-b32e-f1a3564b3409.png', 0, '2026-10-13 17:05:22');
INSERT INTO `ai_chat_message_attachment` VALUES (10, 10, 879658126, 'image', 'image.png', 'png', 'image/png', 263267, 'cw-ai', '879658126/cf0cf9fa-5c88-4399-aa62-923e88f35e43.png', 0, '2026-10-13 17:06:50');
INSERT INTO `ai_chat_message_attachment` VALUES (11, 11, 879658126, 'image', 'image.png', 'png', 'image/png', 1015555, 'cw-ai', '879658126/da30f9ae-5505-4d9a-83f1-fcfc4359b44f.png', 0, '2026-10-13 17:15:01');
INSERT INTO `ai_chat_message_attachment` VALUES (12, 12, 879658126, 'image', 'image.png', 'png', 'image/png', 786464, 'cw-ai', '879658126/1a82cef4-f93b-4aff-8cf8-4ebd85e31c59.png', 0, '2026-10-14 08:53:13');
INSERT INTO `ai_chat_message_attachment` VALUES (13, 13, 879658126, 'image', 'image.png', 'png', 'image/png', 786464, 'cw-ai', '879658126/29c5bb67-723c-4976-bc95-8abcafb60e76.png', 0, '2026-10-14 09:36:51');
INSERT INTO `ai_chat_message_attachment` VALUES (14, 14, 879658126, 'image', 'image.png', 'png', 'image/png', 162918, 'cw-ai', '879658126/bad6ae50-02fa-4cbc-ab38-f408114da61c.png', 0, '2026-10-14 15:30:58');
INSERT INTO `ai_chat_message_attachment` VALUES (15, 15, 879658126, 'image', 'image.png', 'png', 'image/png', 755228, 'cw-ai', '879658126/53ec5eb9-9b82-4675-8558-62acfd7eae46.png', 0, '2026-10-14 15:34:31');
INSERT INTO `ai_chat_message_attachment` VALUES (16, 16, 879658126, 'image', 'image.png', 'png', 'image/png', 395280, 'cw-ai', '879658126/2c575809-40c3-4740-83c5-a34300881f86.png', 0, '2026-10-14 15:42:58');
INSERT INTO `ai_chat_message_attachment` VALUES (17, 17, 968994020, 'file', 'c5e9602a76407f4c3249829247df0554.pdf', 'pdf', 'application/pdf', 2271020, 'cw-ai', '968994020/ca497134-7d9b-4b08-9ccb-65edae1ce284.pdf', 0, '2026-10-14 17:09:55');

-- ----------------------------
-- Table structure for ai_chat_session
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_session`;
CREATE TABLE `ai_chat_session`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '会话主键',
  `session_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话标题，一般取第一条用户提问',
  `user_id` bigint(0) NOT NULL COMMENT '聊天用户ID（后台用户/访客ID）',
  `prompt_template_id` bigint(0) NULL DEFAULT NULL COMMENT '使用的提示词模板id，关联ai_prompt_template',
  `model_id` bigint(0) NULL DEFAULT NULL COMMENT '本次会话使用模型id，关联ai_model',
  `status` tinyint(0) NULL DEFAULT 1 COMMENT '会话状态 1正常 0关闭',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 828376947 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话会话主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_chat_session
-- ----------------------------
INSERT INTO `ai_chat_session` VALUES (368927181, '解析里面的内容', 1, NULL, NULL, 1, NULL, '2026-10-19 08:15:28', '2026-10-19 08:15:28', 0);
INSERT INTO `ai_chat_session` VALUES (828376947, '双绉是什么？', 1, NULL, NULL, 1, NULL, '2026-10-24 15:52:57', '2026-10-24 15:52:57', 0);

-- ----------------------------
-- Table structure for ai_fabric_item
-- ----------------------------
DROP TABLE IF EXISTS `ai_fabric_item`;
CREATE TABLE `ai_fabric_item`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `fabric_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '布号（ERP编号，如 CW-2101）',
  `fabric_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '面料名称（中文）',
  `fabric_name_en` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '面料名称（英文）',
  `composition` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '成分（如 100% Cotton）',
  `spec` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '规格（纱支/密度，如 40x40 133x72）',
  `weight` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '克重（如 120 GSM）',
  `width` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '门幅（如 57/58\"）',
  `cost_material` decimal(10, 2) NOT NULL COMMENT '坯布成本（元/米）',
  `cost_process` decimal(10, 2) NOT NULL COMMENT '织造/工艺成本（元/米）',
  `cost_dyeing` decimal(10, 2) NOT NULL COMMENT '染整成本（元/米）',
  `cost_test` decimal(10, 2) NOT NULL COMMENT '检测成本（元/米）',
  `cost_packing` decimal(10, 2) NOT NULL COMMENT '包装成本（元/米）',
  `lead_time` int(0) NOT NULL DEFAULT 25 COMMENT '交货期（确认订单后天数）',
  `moq` int(0) NOT NULL DEFAULT 1000 COMMENT '最小起订量 MOQ（米）',
  `status` tinyint(0) NOT NULL DEFAULT 1 COMMENT '状态：0-下架 1-上架',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `deleted` tinyint(0) NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-否 1-是',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_fabric_code`(`fabric_code`) USING BTREE,
  INDEX `idx_fabric_item_status`(`status`, `deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '布号主数据表（ERP 面料成本，智能报价用）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_fabric_item
-- ----------------------------
INSERT INTO `ai_fabric_item` VALUES (1, 'CW-2101', '全棉府绸', 'Cotton Poplin', '100% Cotton', '40x40 133x72', '120 GSM', '57/58\"', 6.80, 1.60, 1.90, 0.40, 0.50, 25, 1000, 1, '2026-10-15 08:20:48', '2026-10-15 08:20:48', 0);
INSERT INTO `ai_fabric_item` VALUES (2, 'CW-3205', '涤棉斜纹卡', 'T/C Twill', '65% Polyester 35% Cotton', '32x32 130x70', '180 GSM', '63\"', 5.60, 1.40, 1.60, 0.35, 0.45, 20, 2000, 1, '2026-10-15 08:20:48', '2026-10-15 08:20:48', 0);
INSERT INTO `ai_fabric_item` VALUES (3, 'CW-4408', '全棉牛仔布', 'Cotton Denim', '100% Cotton', '10x10 70x42', '280 GSM', '59\"', 9.50, 2.20, 2.60, 0.50, 0.70, 30, 3000, 1, '2026-10-15 08:20:48', '2026-10-15 08:20:48', 0);
INSERT INTO `ai_fabric_item` VALUES (4, 'CW-5102', '锦纶塔丝隆', 'Nylon Taslan', '100% Nylon', '70D*70D 190T', '90 GSM', '58\"', 7.20, 1.80, 2.10, 0.45, 0.55, 22, 1500, 1, '2026-10-15 08:20:48', '2026-10-15 08:20:48', 0);
INSERT INTO `ai_fabric_item` VALUES (5, 'CW-6301', '人棉印花布', 'Rayon Challis', '100% Rayon', '30x30 68x60', '140 GSM', '55\"', 6.10, 1.50, 2.20, 0.40, 0.50, 28, 1000, 1, '2026-10-15 08:20:48', '2026-10-15 08:20:48', 0);

-- ----------------------------
-- Table structure for ai_keyword_mapping
-- ----------------------------
DROP TABLE IF EXISTS `ai_keyword_mapping`;
CREATE TABLE `ai_keyword_mapping`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `original_word` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原始词（用户口语）',
  `standard_word` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标准术语',
  `category` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类：面料/规格/检测',
  `hit_count` bigint(0) NULL DEFAULT 0 COMMENT '命中次数，统计用',
  `enable` tinyint(0) NULL DEFAULT 1 COMMENT '是否启用',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `deleted` tinyint(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '关键词术语映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_keyword_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for ai_model
-- ----------------------------
DROP TABLE IF EXISTS `ai_model`;
CREATE TABLE `ai_model`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `model_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型名称，如deepseek‑v3',
  `model_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型调用编码',
  `api_base` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'API地址',
  `api_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密钥',
  `temperature` decimal(3, 2) NULL DEFAULT 0.70 COMMENT '温度',
  `max_tokens` int(0) NULL DEFAULT 2048 COMMENT '最大输出token',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用 0禁用 1启用',
  `sort` int(0) NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `creator_id` bigint(0) NULL DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `updater_id` bigint(0) NULL DEFAULT NULL COMMENT '更新人ID',
  `updater_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除 0未删 1已删',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_model_code`(`model_code`) USING BTREE,
  INDEX `idx_enable`(`enable`) USING BTREE,
  INDEX `idx_deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '大模型配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_model
-- ----------------------------

-- ----------------------------
-- Table structure for ai_prompt_template
-- ----------------------------
DROP TABLE IF EXISTS `ai_prompt_template`;
CREATE TABLE `ai_prompt_template`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `agent_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'agent名称，适配多agent的情况',
  `prompt_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板类型: system / user',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提示词内容',
  `model_id` bigint(0) NULL DEFAULT NULL COMMENT '关联ai_model主键',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用',
  `sort` int(0) NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `version` int(0) NULL DEFAULT 1 COMMENT '版本号，乐观锁，编辑自动+1',
  `creator_id` bigint(0) NULL DEFAULT NULL COMMENT '创建人ID',
  `creator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `updater_id` bigint(0) NULL DEFAULT NULL COMMENT '更新人ID',
  `updater_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_prompt_type`(`prompt_type`) USING BTREE,
  INDEX `idx_enable`(`enable`) USING BTREE,
  INDEX `idx_deleted`(`deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI提示词模板表，后台管理，不存储实时用户对话' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_prompt_template
-- ----------------------------
INSERT INTO `ai_prompt_template` VALUES (1, '纺织外贸牛仔面料智能体模板', 'textile‑foreign‑trade‑agent', 'system', '你是纺织牛仔面料外贸多智能体工作台助手，专门服务牛仔面料B2B外贸业务。\r\n业务能力包含客户询盘解析、面料报价分析、竞品面料对比、外贸单证合规校验。\r\n支持多模态：面料图片识别面料成分、检测面料疵点；支持ASR语音提问、TTS语音播报。\r\n可以调用工具完成报表生成、PDF导出、服务器指标查询、日志查询。\r\n回答尽量贴合工厂实际业务，数据不确定时不要编造。\r\n禁止回答和纺织外贸无关的程序开发类问题。\r\n当需要外部信息时，主动调用对应的工具，不要自己虚构数据。', 1, 1, 1, '主业务Agent：纺织综合智能体', 1, 1, 'admin', NULL, NULL, '2026-10-07 17:00:23', '2026-10-07 17:00:23', 0);

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int(0) NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(0) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for rag_document
-- ----------------------------
DROP TABLE IF EXISTS `rag_document`;
CREATE TABLE `rag_document`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `doc_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档名称',
  `oss_object_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'MinIO对象key',
  `oss_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '访问链接',
  `kb_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '知识库分类：process/business/competitor',
  `status` tinyint(0) NULL DEFAULT NULL COMMENT '0待解析，1解析完成，2解析失败',
  `chunk_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '向量切片ID列表',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `deleted` tinyint(0) NULL DEFAULT 0,
  `enabled` tinyint(0) NOT NULL COMMENT '启用：0-停用 1-启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'RAG知识库文档表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rag_document
-- ----------------------------
INSERT INTO `rag_document` VALUES (1, '纺织基础知识大全修订版.docx', 'kb/4ce06af0-2942-4ef4-80b9-f6d0829debd1.docx', 'http://127.0.0.1:9000/cw-ai/kb/4ce06af0-2942-4ef4-80b9-f6d0829debd1.docx?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=name%2F20261023%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20261023T061927Z&X-Amz-Expires=1800&X-Amz-SignedHeaders=host&X-Amz-Signature=dd8799744d63eac4a15722e97f2bcab4a6812a59da13c87c353c68324126bfaa', 'business', 2, '[\"60a50af5-4a02-40cd-b9be-26c0c3cfe5c8\",\"7ffc0a5d-11f1-40b8-bc4a-3ead6bb3114d\",\"eb30ab92-f95b-4c00-b1c0-7b3256e07256\",\"96541b00-128e-46cc-9f0c-417a3768d04c\",\"978ab1ba-8644-4daa-8ba1-c5920f7edbfd\",\"1863b06b-4e0f-4eb6-a07f-228928fc8cdf\",\"8508bf7f-0dcb-4a1b-82d0-69a051516df8\",\"efb023e2-4e41-40f3-b3bf-a0f4ae873d62\",\"feba419e-10d8-405d-986b-89f7538d3d5b\",\"eb5139ff-7a1b-4e42-bb21-d203af0ba72e\",\"9f8a66b6-58cd-48d8-9536-cd49775234dd\",\"913a168c-ca3b-44d9-acba-7b0d97cc3c88\",\"34155315-7353-4a5a-8ece-7ae1bcf6a161\",\"51da3985-a7db-45e3-8f54-8feeb21bacdb\",\"d58b78d0-4fd8-428a-b115-1039b9201cc2\",\"d28f5fd3-2a01-4cfb-a4be-3bcf17b83bf0\"]', 1, '2026-10-23 14:19:28', '2026-11-24 11:08:37', 0, 1);

-- ----------------------------
-- Table structure for sys_agent_model
-- ----------------------------
DROP TABLE IF EXISTS `sys_agent_model`;
CREATE TABLE `sys_agent_model`  (
  `model_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '模型主键',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型展示名称',
  `model_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型编码 deepseek-r1/claude‑3‑5',
  `base_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接口地址',
  `api_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密钥',
  `temperature` decimal(3, 2) NULL DEFAULT 0.70 COMMENT '温度',
  `max_tokens` int(0) NULL DEFAULT 4096 COMMENT '最大输出token',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '0启用 1停用',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`model_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI智能体-大模型配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_agent_model
-- ----------------------------
INSERT INTO `sys_agent_model` VALUES (1, 'DeepSeek‑R1', 'deepseek‑r1', 'https://api.deepseek.com/v1', '', 0.70, 8192, '0', 'admin', '2026-10-05 11:27:37', '', NULL, '纺织智能体默认推理模型');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-10-05 11:27:37', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-10-05 11:27:37', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-10-05 11:27:37', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-10-05 11:27:37', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-10-05 11:27:37', '', NULL, '是否开启注册用户功能（true开启，false关闭）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '纺织科技', 0, '管理员', '15888888888', 'admin@textile.com', '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '技术研发部', 1, '研发员', '15888888888', 'dev@textile.com', '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '业务生产部', 2, '生产主管', '15888888888', 'biz@textile.com', '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(0) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-10-05 11:27:37', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(0) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(0) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2123 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (2000, '纺织智能体', 0, 5, 'agent', NULL, '', '', 1, 0, 'M', '0', '0', '', 'ai', 'admin', '2026-10-05 11:27:37', '', NULL, '纺织AI智能体业务模块');
INSERT INTO `sys_menu` VALUES (2001, 'Agent对话工作台', 2000, 1, 'chat', 'agent/chat/index', '', '', 1, 0, 'C', '0', '0', 'agent:chat:list', 'message', 'admin', '2026-10-05 11:27:37', '', NULL, 'AI对话工作台');
INSERT INTO `sys_menu` VALUES (2002, '知识库管理', 2000, 2, 'knowledge', 'agent/knowledge/index', '', '', 1, 0, 'C', '0', '0', 'agent:knowledge:list', 'book', 'admin', '2026-10-05 11:27:37', '', NULL, 'RAG知识库管理');
INSERT INTO `sys_menu` VALUES (2003, '提示词模板', 2000, 3, 'prompt', 'agent/prompt/index', '', '', 1, 0, 'C', '0', '0', 'agent:prompt:list', 'edit', 'admin', '2026-10-05 11:27:37', '', NULL, '系统提示词模板');
INSERT INTO `sys_menu` VALUES (2004, '向量库管理', 2000, 4, 'vector', 'agent/vector/index', '', '', 1, 0, 'C', '0', '0', 'agent:vector:list', 'database', 'admin', '2026-10-05 11:27:37', '', NULL, '向量库运维');
INSERT INTO `sys_menu` VALUES (2005, '模型配置', 2000, 5, 'model', 'agent/model/index', '', '', 1, 0, 'C', '0', '0', 'agent:model:list', 'cpu', 'admin', '2026-10-05 11:27:37', '', NULL, '大模型参数配置');
INSERT INTO `sys_menu` VALUES (2006, 'AI调用日志', 2000, 6, 'agentLog', 'agent/log/index', '', '', 1, 0, 'C', '0', '0', 'agent:log:list', 'log', 'admin', '2026-10-05 11:27:37', '', NULL, 'AI调用审计日志');
INSERT INTO `sys_menu` VALUES (2100, '对话查询', 2001, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:chat:query', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2101, '对话新增', 2001, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:chat:add', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2102, '对话删除', 2001, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:chat:remove', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '知识库查询', 2002, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:knowledge:query', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2111, '知识库新增', 2002, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:knowledge:add', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2112, '知识库编辑', 2002, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:knowledge:edit', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2113, '知识库删除', 2002, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:knowledge:remove', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2114, '文档上传解析', 2002, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:knowledge:upload', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2120, '模型查询', 2005, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:model:query', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2121, '模型新增', 2005, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:model:add', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2122, '模型修改', 2005, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:model:edit', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2123, '模型删除', 2005, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'agent:model:remove', '#', 'admin', '2026-10-05 11:27:37', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '纺织智能体系统上线通知', '1', 0x3C703EE7BABAE7BB874149E699BAE883BDE4BD93E5B7B2E4B88AE7BABFEFBC8CE694AFE68C81E99DA2E69699E79FA5E8AF86E5BA93E38081E5B7A5E889BAE997AEE7AD943C2F703E, '0', 'admin', '2026-10-05 11:27:37', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int(0) NOT NULL COMMENT '公告id',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `read_time` datetime(0) NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id`, `notice_id`) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(0) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(0) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(0) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(0) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(0) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'admin', '系统管理员', 1, '0', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'biz_user', '业务操作员', 2, '0', 'admin', '2026-10-05 11:27:37', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'guest', '访客用户', 3, '0', 'admin', '2026-10-05 11:27:37', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(0) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '拥有全部权限');
INSERT INTO `sys_role` VALUES (2, '纺织AI业务用户', 'textile_biz', 2, '4', 1, 1, '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '正式业务，可使用全部AI能力，无菜单管理权限');
INSERT INTO `sys_role` VALUES (3, '体验访客角色', 'textile_guest', 3, '0', 1, 1, '0', '0', 'admin', '2026-10-05 11:27:37', '', NULL, '访客：仅允许对话，不可配置模型、知识库');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(0) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(0) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (2, 2001);
INSERT INTO `sys_role_menu` VALUES (2, 2002);
INSERT INTO `sys_role_menu` VALUES (2, 2003);
INSERT INTO `sys_role_menu` VALUES (2, 2006);
INSERT INTO `sys_role_menu` VALUES (2, 2100);
INSERT INTO `sys_role_menu` VALUES (2, 2101);
INSERT INTO `sys_role_menu` VALUES (2, 2102);
INSERT INTO `sys_role_menu` VALUES (2, 2110);
INSERT INTO `sys_role_menu` VALUES (2, 2111);
INSERT INTO `sys_role_menu` VALUES (2, 2112);
INSERT INTO `sys_role_menu` VALUES (2, 2113);
INSERT INTO `sys_role_menu` VALUES (2, 2114);
INSERT INTO `sys_role_menu` VALUES (3, 2000);
INSERT INTO `sys_role_menu` VALUES (3, 2001);
INSERT INTO `sys_role_menu` VALUES (3, 2100);
INSERT INTO `sys_role_menu` VALUES (3, 2101);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(0) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `agent_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT 'AI用户类型：1正式用户 2体验访客guest',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime(0) NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 101, 'admin', '系统管理员', '00', '1', 'admin@textile.com', '15888888888', '0', '', '0192023a7bbd73250516f069df18b500', '0', '0', '127.0.0.1', '2026-10-05 11:27:37', '2026-10-05 11:27:37', 'admin', '2026-10-05 11:27:37', '', NULL, '纺织智能体超级管理员');
INSERT INTO `sys_user` VALUES (2, 102, 'user', '正式业务用户', '00', '1', 'user@textile.com', '15666666666', '0', '', '6ad14ba9986e3615423dfca256d04e3f', '0', '0', '127.0.0.1', '2026-10-05 11:27:37', '2026-10-05 11:27:37', 'admin', '2026-10-05 11:27:37', '', NULL, '纺织业务正式账号');
INSERT INTO `sys_user` VALUES (3, NULL, 'guest', '体验访客', '00', '2', 'guest@textile.com', '', '2', '', 'fcf41657f02f88137a1bcf068a32c0a3', '0', '0', '127.0.0.1', '2026-10-05 11:27:37', '2026-10-05 11:27:37', 'admin', '2026-10-05 11:27:37', '', NULL, '访客体验账号，有调用次数限制');

-- ----------------------------
-- Table structure for sys_user_agent_quota
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_agent_quota`;
CREATE TABLE `sys_user_agent_quota`  (
  `quota_id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL COMMENT '关联sys_user.user_id',
  `day_quota` int(0) NULL DEFAULT 50 COMMENT '每日最大调用次数',
  `day_used` int(0) NULL DEFAULT 0 COMMENT '今日已调用次数',
  `total_quota` bigint(0) NULL DEFAULT 10000 COMMENT '总额度',
  `total_used` bigint(0) NULL DEFAULT 0 COMMENT '已消耗总次数',
  `reset_time` datetime(0) NULL DEFAULT NULL COMMENT '额度重置时间',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`quota_id`) USING BTREE,
  UNIQUE INDEX `uk_uid`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI智能体-用户调用额度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_agent_quota
-- ----------------------------
INSERT INTO `sys_user_agent_quota` VALUES (1, 1, 9999, 0, 99999, 0, NULL, '2026-10-05 11:27:37', NULL);
INSERT INTO `sys_user_agent_quota` VALUES (2, 2, 200, 0, 10000, 0, NULL, '2026-10-05 11:27:37', NULL);
INSERT INTO `sys_user_agent_quota` VALUES (3, 3, 10, 0, 100, 0, NULL, '2026-10-05 11:27:37', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `post_id` bigint(0) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (3, 3);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (3, 3);

SET FOREIGN_KEY_CHECKS = 1;
