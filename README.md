# 🔧 Agent MCP Hub

> **"MCP = 手和脚"** — 精选 MCP Server 配置，让 Agent 真正做事。

## 📖 什么是 MCP？

MCP（Model Context Protocol）是 Anthropic 开发的开放协议，定义了 AI Agent 与外部工具交互的标准方式。

**本质：** 工具调用标准 — 一次开发，全 Agent 使用。

**类比：** 没有 MCP，Agent 知道流程但无法操作 GitHub；有了 MCP，Agent 能计划→执行→验证→修复，形成闭环。

## 🏗️ 项目结构

```
agent-mcp/
├── README.md              # 本文件
├── deploy.sh              # 一键部署脚本
├── configs/               # Agent 配置文件
│   ├── claude_desktop.json    # Claude Desktop MCP 配置
│   ├── claude_code.json       # Claude Code MCP 配置
│   ├── cursor.json            # Cursor MCP 配置
│   └── hermes.yaml            # Hermes Agent MCP 配置
├── servers/               # MCP Server 信息
│   ├── official.md        # 官方参考实现
│   ├── community.md        # 社区精选
│   └── self-hosted.md    # 自托管方案
└── references/            # 参考资料
    ├── mcp-architecture.md
    └── security-guide.md
```

## 🚀 快速部署

### 方式一：一键脚本（推荐）

```bash
git clone https://github.com/kongjie0325-art/agent-mcp.git
cd agent-mcp
bash deploy.sh
```

### 方式二：手动配置

```bash
# 1. 查看需要的 MCP Server
cat configs/claude_desktop.json

# 2. 根据你的 Agent 类型选择配置
# Claude Desktop → 复制 configs/claude_desktop.json 到 ~/.claude/settings.json
# Claude Code → 复制 configs/claude_code.json 到 ~/.claude.json
# Cursor → 复制 configs/cursor.json 到 ~/.cursor/config.json

# 3. 安装 MCP Server（以 npx 方式为例）
npx -y @modelcontextprotocol/server-filesystem /opt/data
npx -y @modelcontextprotocol/server-github
```

## 📦 精选 MCP Server 清单

### 🏗️ 基础设施

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **Filesystem** | `npx -y @modelcontextprotocol/server-filesystem` | 本地文件读写 |
| **Browser** | `npx -y @modelcontextprotocol/server-browser` | 浏览器控制 |
| **Docker** | `npx -y @modelcontextprotocol/server-docker` | 容器管理 |
| **SQLite** | `npx -y @modelcontextprotocol/server-sqlite` | SQLite 数据库 |

### 🐙 GitHub

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **GitHub** | `npx -y @modelcontextprotocol/server-github` | Issue/PR/代码搜索 |
| **GitHub CLI** | `gh mcp-server` | gh CLI MCP 封装 |

### 🔍 搜索 & 浏览

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **Brave Search** | `npx -y @modelcontextprotocol/server-brave-search` | 网页搜索 |
| **Puppeteer** | `npx -y @modelcontextprotocol/server-puppeteer` | 无头浏览器 |
| **Fetch** | `npx -y @modelcontextprotocol/server-fetch` | URL 内容获取 |

### 📋 生产力

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **Notion** | `npx -y @modelcontextprotocol/server-notion` | Notion 读写 |
| **Slack** | `npx -y @modelcontextprotocol/server-slack` | Slack 消息 |
| **Google Drive** | `npx -y @modelcontextprotocol/server-google-drive` | Google Drive |
| **Linear** | `npx -y @modelcontextprotocol/server-linear` | Linear 项目管理 |

### 🗄️ 数据库

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **PostgreSQL** | `npx -y @modelcontextprotocol/server-postgres` | PostgreSQL 查询 |
| **Redis** | `npx -y @modelcontextprotocol/server-redis` | Redis 操作 |
| **Memory** | `npx -y @modelcontextprotocol/server-memory` | 知识图谱记忆 |

### 🤖 AI & 推理

| MCP Server | 安装方式 | 说明 |
|-----------|---------|------|
| **Sequential Thinking** | `npx -y @modelcontextprotocol/server-sequential-thinking` | 结构化思考 |
| **E2B Sandbox** | `npx -y @e2b/mcp-server` | 云沙箱执行代码 |
| **Firecrawl** | `npx -y @firecrawl/mcp-server` | 网页→LLM 就绪数据 |

## 📊 MCP Server 对比表

| 类别 | Server | Stars | 语言 | 安全等级 |
|------|--------|-------|------|---------|
| 官方参考 | modelcontextprotocol/servers | 62k+ | TS/Python | ✅ 高 |
| 文件系统 | microsoft/markitdown | 90k+ | Python | ✅ 高 |
| 浏览器 | ChromeDevTools/chrome-devtools-mcp | 8k+ | TS | ✅ 高 |
| 搜索 | firecrawl/firecrawl-mcp | 5k+ | TS | ✅ 高 |
| 沙箱 | e2b-dev/mcp-server | 3k+ | TS | ⚠️ 中 |
| 思考 | modelcontextprotocol/server-sequential-thinking | 5.5k+ | TS | ✅ 高 |

## 🔒 安全注意事项

1. **最小权限原则**：只授予必要的权限
2. **沙箱隔离**：敏感操作在容器中执行
3. **审计日志**：记录所有 MCP 调用
4. **Token 管理**：定期轮换 API Token

详见 [references/security-guide.md](references/security-guide.md)

## 🔗 相关项目

- **[agent-skills](https://github.com/kongjie0325-art/agent-skills)** — Skills 精选 + 部署
- **[agent-plugins](https://github.com/kongjie0325-art/agent-plugins)** — Plugin 精选 + 部署

## 📄 License

MIT
