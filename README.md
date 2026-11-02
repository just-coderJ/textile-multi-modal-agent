# 纺织外贸多智能体运营工作台（后端）

面向 **B2B 牛仔面料外贸**场景的多智能体运营工作台后端，基于 **Spring Boot 3 + LangChain4j + 通义千问（DashScope）** 构建。围绕综合问答、智能报价、竞品调研、合同合规校验、面料疵点识别、后台管理六大业务能力，结合 RAG 检索、MCP 联网工具、多模态视觉与语音识别，为外贸业务员提供从询盘到报价、单证、质检的一站式 AI 辅助。

> 前端仓库：[`ai-code-helper-ui`](../ai-code-helper-ui)（Vue 3 + Vite）。

---

## ✨ 核心业务功能

| 业务模块      | 说明 | 入口接口 | AI 能力                                  |
|-----------| --- | -- |----------------------------------------|
| 💬 综合问答   | 文字 / 图片 / 文档多模态对话，SSE 流式输出，多轮记忆与会话历史 | `GET·POST /api/ai/chat` | LangChain4j AiServices + DashScope 多模态 |
| 💰 智能报价   | 基于 ERP 布号成本，一键生成中英文报价邮件（金额零篡改） | `GET /api/erp/fabric/list`、`POST /api/quote/email` | 大模型只写文案，数字确定性计算                        |
| 🔍 竞品调研   | 按面料关键词聚合各平台竞品报价，输出对比表与报价建议 | `GET /api/research/fabric` | MCP 联网搜索（可选）+ 模型知识                     |
| 📋 合同合规校验 | 解析 txt/md/pdf 合同，逐条审查 10 类必备条款与高风险表述 | `POST /api/compliance/check` | Generator + Reflection 双轮审查            |
| 🧵 面料疵点识别 | 视觉模型两段式检测布面疵点，输出位置/类型/严重程度 | `POST /api/fabric/defect/detect` | DashScope 多模态视觉                        |
| 📚 后台管理   | 用户角色权限、动态菜单、模型配置、调用统计、行业文档落 MinIO 向量化管理| `/api/admin/**`、`/api/knowledge/**` | RAG 向量检索 + 系统权限管控                              |
| 🎙️ 语音识别  | 综合问答语音输入，服务端 ASR（16k WAV → 文本） | `POST /api/ai/asr` | 百炼 paraformer                          |

**贯穿所有模块的三条设计原则**：

1. **确定性的事交给代码，创造性的事交给模型**——取数、算价、评分重算、正则风险由代码保证；措辞、审查意见、行情分析、图像理解交给模型。
2. **每一层都能降级**——模型 / MCP / 视觉任一环失败，都有下一级兜底（本地模板、规则引擎、演示数据），前端永远拿得到可渲染结果。
3. **模型 I/O 只在 Agent 层**——Controller 不碰模型，Service 不写 prompt，Agent 不碰 DB / Servlet，职责清晰、易测试、易换模型。

---

## 🧱 技术栈

| 分类 | 技术 | 版本 |
| --- | --- | --- |
| 语言 / 框架 | Java + Spring Boot | 21 / 3.5.3 |
| AI 编排 | LangChain4j（core） | 1.1.0 |
| 模型接入 | langchain4j-community-dashscope-spring-boot-starter | 1.1.0-beta7 |
| 流式 / 工具 | langchain4j-reactor 1.1.0-beta7、langchain4j-mcp 1.0.0-beta5 | — |
| 持久层 | MyBatis-Plus（spring-boot3-starter）+ MySQL | 3.5.17 |
| 对象存储 | MinIO | 8.5.7 |
| 鉴权 | JWT（jjwt）+ BCrypt（spring-security-crypto） | 0.12.6 |
| 文档解析 | Apache PDFBox | 3.0.3 |
| 接口文档 | springdoc-openapi（Swagger UI） | 1.6.14 |
| 工具库 | Hutool、Lombok、jsoup | — |
| 前端 | Vue 3 + Vue Router + Vite + axios + marked | 独立仓库 |

**大模型**：通义千问系列——文本 `qwen-max`、多模态 `qwen3-omni-flash`（PDF 理解自动切 `qwen3.8-flash`）、向量 `text-embedding` 系列、语音 `paraformer-realtime-v2`。

---

## 🏗️ 系统架构

采用清晰的**三层职责契约**，业务模块统一遵循：

```
HTTP 请求
   │
   ▼
Controller  ── HTTP 参数解析、multipart 处理、统一返回体 Result 信封
   │
   ▼
Service     ── 应用编排：输入解析、落库、normalize、降级兜底、summary 重算
   │
   ▼
Agent       ── 模型 I/O：持有 prompt 常量、调用大模型、解析输出 JSON（无状态 @Component 单例）
   │
   ▼
LangChain4j AiServices / DashScope SDK  ── 记忆 · 护栏 · RAG · 工具 · MCP · 多模态
```

- **Agent 层**（`ai/agent`）：抽象基类 `BizAgent`（注入 `myQwenChatModel`，提供 `chat` / `chatJson`）+ 五个业务 Agent：`QaAgent`（问答门面）、`QuotationAgent`（报价文案）、`CompetitorAgent`（竞品调研 + MCP）、`ComplianceAgent`（合规双轮）、`FabricAgent`（视觉两段式）。
- **RAG**：`RagConfig` 把 `EmbeddingStore<TextSegment>` 提为单例 `@Bean`，`ContentRetriever` 与 `KnowledgeBaseService` 共用同一实例；`InMemoryEmbeddingStore` 重启即空，由 `@PostConstruct` 遍历启用文档重建向量。
- **鉴权**：`JwtAuthInterceptor` 保护常规接口；`/ai/**` 走 `OptionalAuthInterceptor`（有 token 记名、无 token 放行），SSE 场景经 `?token=` 传递登录态（`EventSource` 无法设请求头）。

---

## 📁 目录结构

```
ai-code-helper/
├── src/main/java/com/example/aicodehelper/
│   ├── ai/
│   │   ├── agent/          # 业务 Agent：BizAgent 基类 + Qa/Quotation/Competitor/Compliance/Fabric
│   │   ├── app/            # AiServices 装配工厂、高阶多模态封装
│   │   ├── model/          # QwenChatModelConfig 模型 Bean
│   │   ├── rag/            # RagConfig：EmbeddingStore / ContentRetriever
│   │   ├── mcp/            # McpConfig：百度 ai_search 联网搜索（可选）
│   │   ├── guardrail/      # ProfanityGuardrail 输入护栏
│   │   ├── tools/          # MathTools 自定义工具
│   │   └── listener/       # ChatModelListener 请求/响应日志与用量统计
│   ├── controller/
│   │   ├── ai/             # 业务接口：问答/报价/竞品/合规/面料/知识库/ASR/后台统计
│   │   ├── admin/          # 认证、菜单、角色、部门
│   │   └── file/           # 文件上传下载
│   ├── service/
│   │   ├── ai/             # 业务编排 Service
│   │   ├── admin/          # 登录、权限、配额、调用统计
│   │   ├── file/           # MinIO 存储
│   │   └── impl/           # MyBatis-Plus ServiceImpl
│   ├── domain/             # 实体（snake_case + @TableField）、DTO、VO
│   ├── mapper/             # MyBatis-Plus Mapper
│   ├── common/             # Result 信封、AiJson、SecurityUtils、拦截器、异常处理
│   └── config/             # WebMvcConfig、CORS 等
├── src/main/resources/
│   ├── application.yml           # 主配置（端口 8881、context-path /api、profile）
│   ├── application-prod.yml      # 生产配置（全部走环境变量占位符）
│   ├── application-local.yml     # 本地配置（含密钥，已 .gitignore，不入库）
│   ├── system-prompt.txt         # 综合问答人设 System Prompt
│   └── mapper/ · generator/mapper/
├── db/
│   ├── create_table.sql          # 建表脚本
│   └── init_data.sql             # 初始化数据
├── pom.xml
└── settings.xml                  # Maven 阿里云镜像
```

---

## 🚀 快速开始

### 环境要求

- JDK 21
- Maven 3.8+
- MySQL 8.x
- MinIO（对象存储）
- 通义千问（DashScope）API Key

### 1. 准备数据库

```bash
# 创建数据库并执行建表与初始化脚本
mysql -u root -p -e "CREATE DATABASE \`cw-ai\` DEFAULT CHARACTER SET utf8mb4;"
mysql -u root -p cw-ai < db/create_table.sql
mysql -u root -p cw-ai < db/init_data.sql

# Existing databases: add model management columns and seed rows
mysql -u root -p cw-ai < db/model_management.sql
```

> ⚠️ 若使用了知识库 / 面料等业务，请确认 `rag_document`、`ai_fabric_item` 等表已建（存量库需执行 `create_table.sql` 中对应的 `ALTER` 语句补列），否则相关接口会因 `BadSqlGrammar` 报 500。

### 2. 配置环境变量

生产 profile（默认 `active: prod`）全部通过环境变量注入，**不含任何硬编码密钥**：

| 环境变量 | 必填 | 说明 | 默认值 |
| --- | --- | --- | --- |
| `LANGCHAIN4J_API_KEY` | ✅ | 通义千问 DashScope API Key | — |
| `minio_endpoint` | ✅ | MinIO 服务地址 | — |
| `minio_user` | ✅ | MinIO Access Key | — |
| `minio_password` | ✅ | MinIO Secret Key | — |
| `MYSQL_HOST` / `MYSQL_PORT` / `MYSQL_DATABASE` | ❌ | MySQL 连接 | `localhost` / `3306` / `cw-ai` |
| `MYSQL_USERNAME` / `MYSQL_PASSWORD` | ❌ | MySQL 账号 | `root` / `123456` |
| `BAIDUZP_API_KEY` | ❌ | 百度智能云 Key（竞品调研联网 MCP，缺失时自动降级离线） | 空 |
| `TOKEN_SECRET` | ❌ | JWT 签名密钥 | 内置默认值（生产请务必覆盖） |

也可以本地开发时用 `application-local.yml`（已被 `.gitignore` 忽略，不会提交），把 `application.yml` 的 `spring.profiles.active` 改为 `local`。

### 3. 启动后端

```bash
mvn -s settings.xml spring-boot:run
# 或打包运行
mvn -s settings.xml clean package -DskipTests
java -jar target/ai-code-helper-0.0.1-SNAPSHOT.jar
```

服务启动后：
- 接口根路径：`http://localhost:8881/api`
- 各接口在 Controller 上以 springdoc `@Tag` / `@Operation` 注解描述；如需在线调试可自行装配与 Spring Boot 3 匹配的 `springdoc-openapi-starter-webmvc-ui`。

### 4. 启动前端

前端为独立仓库 [`ai-code-helper-ui`](../ai-code-helper-ui)：

```bash
cd ../ai-code-helper-ui
npm install
npm run dev        # 开发（Vite 已代理 /api → http://localhost:8881）
npm run build      # 生产构建
```

---

## 🔌 API 一览

> 所有接口统一前缀 `/api`（`server.servlet.context-path`），统一返回体 `Result`（`{ code, msg, data }`）。

### 业务接口

| 方法 | 路径 | 说明 | 鉴权 |
| --- | --- | --- | --- |
| `GET` | `/api/ai/chat` | 纯文本流式问答（SSE，`?token=` 传登录态） | 可选 |
| `POST` | `/api/ai/chat` | 多模态问答（multipart：`memoryId/message/images/files`，SSE） | 可选 |
| `POST` | `/api/ai/asr` | 语音转文字（16k 单声道 WAV） | 可选 |
| `GET` | `/api/erp/fabric/list` | ERP 布号成本列表（确定性取数） | JWT |
| `POST` | `/api/quote/email` | 生成报价邮件 | JWT |
| `GET` | `/api/research/fabric` | 面料竞品行情调研 | JWT |
| `POST` | `/api/compliance/check` | 合同条款合规校验（文件或文本） | JWT |
| `POST` | `/api/fabric/defect/detect` | 面料疵点检测（图片） | JWT |
| `POST` | `/api/knowledge/upload` | 上传知识库文档并向量化 | JWT |
| `GET` | `/api/knowledge/list` | 知识库文档列表 | JWT |
| `PUT` | `/api/knowledge/{id}/enabled` | 启用 / 停用文档 | JWT |
| `POST` | `/api/knowledge/{id}/reindex` | 重新向量化 | JWT |
| `DELETE` | `/api/knowledge/{id}` | 删除文档（逻辑删 + 移除向量 + 删 MinIO） | JWT |

### 认证与系统

| 方法 | 路径 | 说明 |
| --- | --- | --- |
| `POST` | `/api/login` | 登录，返回 JWT |
| `POST` | `/api/logout` | 退出（无状态，客户端删令牌） |
| `GET` | `/api/getInfo` | 当前用户 + 角色 + 权限 |
| `GET` | `/api/getRouters` | 动态路由菜单 |

此外还有后台统计（`AdminStatsController`）、模型/关键词/提示词配置、业务日志、文件上传等管理接口。

---

## 🔒 安全说明

- **密钥不入库**：含真实 API Key 的 `application-local.yml` 已列入 `.gitignore` 且未被 Git 跟踪；被跟踪的 `application-prod.yml` 全部使用 `${ENV_VAR}` 占位符。
- **密码加密**：用户密码使用 BCrypt 存储。
- **生产部署**：请务必通过环境变量注入密钥，并覆盖默认的 `TOKEN_SECRET`。

---

## 📄 License

MIT
