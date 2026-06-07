# Hermes Agent MCP 分类目录

> 原生 MCP 客户端 + 已配置 MCP Server + 生态全景

---

## 📊 总览

| 分类 | 数量 | 说明 |
|------|------|------|
| 🔧 已配置 MCP Server | 1 | GitHub（通过 npx） |
| 📖 MCP 使用 Skill | 1 | native-mcp（完整文档） |
| 🌐 生态中的 MCP Server | 3000+ | 社区生态 |

---

## 🔧 已配置的 MCP Server

### GitHub MCP

```yaml
mcp_servers:
  github:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "ghp_..."
    timeout: 60
```

**提供的工具：**
- `mcp_github_list_issues` — 列出 Issues
- `mcp_github_create_pull_request` — 创建 PR
- `mcp_github_search_code` — 搜索代码
- `mcp_github_get_file_contents` — 获取文件内容
- … 等

---

## 📖 MCP 使用 Skill：native-mcp

Hermes 内置的原生 MCP 客户端，功能远超普通 MCP 桥接。

### 核心能力

| 能力 | 说明 |
|------|------|
| **自动发现** | 启动时自动连接所有 MCP Server，发现工具 |
| **工具注册** | 工具命名为 `mcp_{server}_{tool}` 格式 |
| **全平台注入** | 工具自动注入所有 platform toolsets |
| **持久连接** | 长连接 + 断线重连（指数退避，最多 5 次） |
| **安全隔离** | 环境变量过滤，只传递安全基线变量 |
| **凭证脱敏** | 错误消息自动脱敏 token/key/secret |
| **Sampling** | 支持 MCP 服务端发起的 LLM 请求 |

### 传输类型

| 传输 | 说明 | 适用场景 |
|------|------|---------|
| **stdio** | 子进程 stdin/stdout | 本地 MCP Server（npx/uvx） |
| **HTTP/StreamableHTTP** | 远程 URL | 远程/共享 MCP Server |

### 配置示例

```yaml
# Stdio 传输
mcp_servers:
  filesystem:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-filesystem", "/opt/data"]

# HTTP 传输
mcp_servers:
  company_api:
    url: "https://mcp.example.com/v1/mcp"
    headers:
      Authorization: "Bearer sk-..."
```

### 安全模型

```
环境变量过滤:
  只传递: PATH, HOME, USER, LANG, LC_ALL, TERM, SHELL, TMPDIR, XDG_*
  不传递: API keys, tokens, secrets（除非 env 显式指定）

凭证脱敏规则:
  - GitHub PATs (ghp_...)
  - OpenAI keys (sk-...)
  - Bearer tokens
  - token=, key=, API_KEY=, password=, secret=
```

---

## 🌐 MCP 生态全景

### 官方参考实现（modelcontextprotocol/servers）

| Server | 说明 |
|--------|------|
| `filesystem` | 安全文件系统访问 |
| `github` | GitHub 仓库/Issue/PR/Code |
| `postgresql` | PostgreSQL 数据库 |
| `sqlite` | SQLite 数据库 |
| `slack` | Slack 消息/频道/搜索 |
| `brave-search` | Web + 本地搜索 |
| `playwright` | 浏览器自动化 |
| `puppeteer` | Chrome 浏览器控制 |

### 按类别

| 类别 | 代表 Server |
|------|------------|
| 🔧 **开发** | GitHub, GitLab, Filesystem, Docker, SSH |
| 🌐 **网络** | Playwright, Puppeteer, Fetch, Brave Search |
| 🗄️ **数据库** | PostgreSQL, MySQL, SQLite, Redis, Elasticsearch |
| ☁️ **云平台** | AWS, GCP, Cloudflare, Vercel |
| 💬 **通讯** | Slack, Discord, Telegram, Email |
| 📊 **监控** | Prometheus, Grafana, Sentry, Datadog |
| 🧠 **AI 服务** | HuggingFace, OpenAI, Anthropic |
| 🎵 **多媒体** | Spotify, YouTube, ImageGen |

### 社区生态规模

- **3000+** 社区 MCP Server（2026 年）
- **Linux Foundation Agentic AI Foundation** 背书
- 所有主流 Agent 框架原生支持（Claude Code / Codex / Cursor / Cline / Hermes）

---

## 🔄 MCP vs Hermes 内置工具

Hermes 的工具体系：

```
┌────────────────────────────────────┐
│          Hermes 工具注册表          │
├────────────────────────────────────┤
│  内置工具 (Built-in)               │
│  ├── terminal                      │
│  ├── read_file / write_file        │
│  ├── web_search / web_extract      │
│  ├── browser_click / browser_type  │
│  ├── execute_code                  │
│  └── ...                           │
├────────────────────────────────────┤
│  MCP 工具 (mcp_{server}_{tool})    │
│  ├── mcp_github_list_issues        │
│  ├── mcp_github_create_pr          │
│  └── ...                           │
├────────────────────────────────────┤
│  平台工具 (Platform)                │
│  ├── send_message (Telegram/等)    │
│  ├── spotify_playback              │
│  └── ...                           │
├────────────────────────────────────┤
│  插件工具 (Plugin)                  │
│  ├── meet_join / meet_transcript   │
│  └── ...                           │
└────────────────────────────────────┘
```

所有工具对 Agent 来说都是"一等公民"——Agent 不区分内置工具、MCP 工具还是插件工具。

---

## 🚀 快速添加新 MCP Server

```bash
# 1. 编辑 config.yaml
nano ~/.hermes/config.yaml

# 2. 在 mcp_servers 下添加
mcp_servers:
  my_server:
    command: npx
    args: ["-y", "@mcp/my-server"]
    env:
      MY_API_KEY: "..."

# 3. 重启 Hermes
hermes gateway restart

# 4. 验证
hermes status  # 查看 MCP 连接状态
```
