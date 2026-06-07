# AI Agent 框架架构分析

> Hermes Agent 内部架构 + 三方框架对比

---

## 📊 总览

| 框架 | Skills | MCP | Plugin | Memory | Subagent | 自主性 |
|------|--------|-----|--------|--------|----------|--------|
| **Hermes Agent** | ✅ 81 | ✅ 原生 | ✅ 40+ | ✅ 多级 | ✅ delegate_task | 高 |
| **Claude Code** | ✅ 1000+ | ✅ 原生 | ✅ 市场 | ✅ | ✅ Agent Teams | 高 |
| **OpenAI Codex** | ✅ AGENTS.md | ✅ | ❌ | 🟡 | ❌ | 中高 |
| **Cline** | 🟡 rules | ✅ | 🟡 | 🟡 | ❌ | 中(人工) |
| **Roo Code** | ✅ Mode | ✅ | ✅ | 🟡 | ✅ Cloud | 高 |
| **OpenHands** | 🟡 | ✅ | ✅ SDK | ✅ | ✅ 原生 | 高 |

---

## 🏗️ Hermes Agent 架构

### 架构全景

```
用户
  │
  ▼
┌──────────────────────────────────────────────┐
│              Gateway / CLI / TUI              │
│         (FastAPI Web / Click CLI / Ink TUI)   │
└──────────┬───────────────────────────────────┘
           │
┌──────────▼───────────────────────────────────┐
│                 Agent Loop                    │
│  (推理 → 工具调用 → 观察 → 压缩 → 重复)       │
│                                               │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐        │
│  │ Planner │ │Executor │ │Verifier │        │
│  └─────────┘ └─────────┘ └─────────┘        │
└──────────┬───────────────────────────────────┘
           │
┌──────────▼───────────────────────────────────┐
│              工具注册表 (Unified)              │
│                                               │
│  内置工具         MCP 工具        插件工具      │
│  ├── terminal   ├── mcp_github   ├── spotify  │
│  ├── read_file  ├── mcp_fs       ├── meet_join│
│  ├── web_search ├── mcp_docker   └── ...      │
│  └── ...       └── ...                        │
└──────────┬───────────────────────────────────┘
           │
┌──────────▼───────────────────────────────────┐
│              平台适配层                        │
│  Telegram / Discord / Slack / Teams / LINE /  │
│  Google Chat / IRC / ntfy / SimpleX           │
└──────────┬───────────────────────────────────┘
           │
┌──────────▼───────────────────────────────────┐
│              记忆系统                          │
│  短期上下文 (会话内)                           │
│  长期记忆 (Mem0 / Supermemory / Holographic)   │
│  会话搜索 (SQLite FTS5)                        │
└──────────┬───────────────────────────────────┘
           │
┌──────────▼───────────────────────────────────┐
│              插件系统                          │
│  40+ 个插件 (搜索/生成/平台/记忆/浏览器)        │
│  Hook 机制 (9 种事件)                         │
│  Plugin.yaml 元数据                           │
└──────────────────────────────────────────────┘
```

### Hermes 的 Skills → MCP → Plugin 分层

```
请求：帮我分析 GitHub 项目并部署到 VPS

  ① Skills 层（知道怎么做）
     ├── github-pr-workflow → PR 审查流程
     ├── devops-deploy → 部署标准流程
     └── systematic-debugging → 如果出错
           │
  ② MCP 层（能执行）
     ├── GitHub MCP → 读代码、查 PR
     ├── Filesystem MCP → 写部署脚本
     └── (SSH MCP → 连接 VPS，如果配置了)
           │
  ③ Plugin 层（功能补充）
     ├── disk-cleanup → 部署后清理临时文件
     ├── security-guidance → 写入时安全审查
     └── spotify → 部署完成听首歌 🎵
           │
  ④ 平台层（结果交付）
     ├── Telegram → 推送部署结果
     └── Discord → 通知团队
```

---

## 🔬 三方框架深度对比

### 1. Claude Code（Anthropic）

**架构特点：**
- **最完整的生态**：Skills + MCP + Plugin + Memory + Subagent + Hooks
- **29 种 Hooks**：事件驱动的自动化层
- **Agent Teams**：多 Agent 协调
- **Plugin Marketplace**：432+ 插件，2769 Skills
- **热加载 Skills**：无需重启

**适合：** 全栈开发 / 复杂 Agent 编排 / 专业代码工作流

**不足：** Model 锁定（只用 Claude）

---

### 2. OpenAI Codex CLI

**架构特点：**
- **极简设计**：AGENTS.md + MCP + Sandbox
- **零数据留存**：状态无关设计
- **安全沙箱**：代码在隔离环境执行
- **Prompt 缓存**：线性性能而非二次
- **1M token 上下文**

**适合：** CLI 工作流 / CI/CD / 自动化任务

**不足：** 无 Plugin 扩展系统 / 弱记忆

---

### 3. Cline（VS Code Extension）

**架构特点：**
- **Human-in-the-Loop**：每个操作需用户批准
- **MCP Marketplace**：最丰富的 MCP 市场
- **58K+ Stars**：最大社区
- **多模型支持**：Claude / GPT / DeepSeek / Gemini

**适合：** 安全优先 / 初学者 / VS Code 用户

**不足：** 人工审核限制自主性 / 弱记忆

---

### 4. Roo Code（VS Code Extension）

**架构特点：**
- **多 Mode 系统**：不同 Agent 人格模式
- **Cloud Agents**：GitHub Actions 触发自主 Agent
- **Modes Marketplace**：社区模式市场
- **从 Cline fork**，添加多模型 + 多 Mode

**适合：** 多模式工作流 / 并行任务

**不足：** 记忆薄弱

---

### 5. OpenHands

**架构特点：**
- **企业级 SDK**：Python SDK 扩展
- **多 Agent 编排**：内置协调器
- **浏览器 UI**：可视化管理
- **MCP 兼容**：2025 年添加

**适合：** 企业部署 / 多 Agent 系统 / SDK 开发

**不足：** Skills 系统较弱

---

## 📐 架构设计模式对比

### Skills 实现方式

| 框架 | Skills 格式 | 触发方式 | 生态系统 |
|------|------------|---------|---------|
| Hermes | SKILL.md (frontmatter) | 自动加载 + 手动 | 81 Skills |
| Claude Code | SKILL.md + Commands | 自动 + 斜杠命令 + 条件 | 1000+ Skills |
| Codex | AGENTS.md | 文件引用 | 社区驱动 |
| Cline | .clinerules | 项目规则 | 有限 |
| Roo Code | Mode 配置文件 | 模式切换 | 社区市场 |

### MCP 集成方式

| 框架 | MCP 支持 | 传输类型 | 工具发现 |
|------|---------|---------|---------|
| Hermes | ✅ 原生 (Python mcp SDK) | stdio + HTTP | 自动 |
| Claude Code | ✅ 原生 | stdio + HTTP | 自动 |
| Codex | ✅ 原生 | stdio | 自动 |
| Cline | ✅ 原生 | stdio + HTTP | 自动 + 市场 |
| Roo Code | ✅ 原生 | stdio + HTTP | 自动 |

### Plugin 扩展能力

| 框架 | Plugin 系统 | Hook 机制 | 市场 |
|------|------------|----------|------|
| Hermes | ✅ plugin.yaml | 9 种 Hook | 内置 40+ |
| Claude Code | ✅ 插件包 | 29 种 Hook | 432+ 插件 |
| Codex | ❌ 无 | ❌ | ❌ |
| Cline | 🟡 有限 | ❌ | 🟡 MCP 市场 |
| Roo Code | ✅ Mode 市场 | ❌ | ✅ Mode 市场 |

---

## 🧬 哪个最接近「真正的自主 Agent」？

### 评分维度

| 维度 | 权重 | Hermes | Claude Code | Codex | Cline | Roo Code | OpenHands |
|------|------|--------|-------------|-------|-------|----------|-----------|
| Skills 生态 | 25% | 7/10 | 10/10 | 5/10 | 4/10 | 6/10 | 5/10 |
| MCP 集成 | 20% | 9/10 | 9/10 | 8/10 | 9/10 | 9/10 | 7/10 |
| Plugin 扩展 | 15% | 9/10 | 9/10 | 2/10 | 4/10 | 7/10 | 7/10 |
| Memory | 15% | 8/10 | 8/10 | 4/10 | 3/10 | 3/10 | 7/10 |
| Subagent | 10% | 7/10 | 9/10 | 2/10 | 2/10 | 6/10 | 9/10 |
| 自主性 | 10% | 8/10 | 8/10 | 7/10 | 4/10 | 7/10 | 8/10 |
| 模型灵活度 | 5% | 6/10 | 3/10 | 4/10 | 10/10 | 10/10 | 8/10 |
| **总分** | 100% | **7.9** | **8.5** | **4.6** | **4.9** | **6.4** | **6.9** |

### 排名

| 排名 | 框架 | 总分 | 最强项 | 最弱项 |
|------|------|------|--------|--------|
| 🥇 | Claude Code | 8.5 | Skills + Plugin 生态 | 模型锁定 |
| 🥈 | Hermes Agent | 7.9 | Plugin + 平台 + 自主性 | Skills 数量 |
| 🥉 | OpenHands | 6.9 | 多 Agent + 企业 | Skills |
| 4 | Roo Code | 6.4 | 模型灵活度 | Memory |
| 5 | Cline | 4.9 | 社区 + MCP | 自主性(人工) |
| 6 | Codex | 4.6 | 简洁 + 安全 | 无 Plugin |

---

## 💡 经验总结

### Skills 的决定性作用

> 一个 $200/月的 Claude Code Max 订阅 + 好的 Skills ≈ 一个 $200/月的 Codex + 20 个 MCP 但无 Skills

Skills 决定了 Agent 的 **思考质量**：
- 好的 DevOps Skill 让 Agent 像高级工程师一样部署
- 没有 Skill 的 Agent 像实习生一样乱试

### MCP 的执行力价值

> Skills 是思想，MCP 是行动

没有 MCP 的 Skills 只是"纸上谈兵"——Agent 知道该做什么，但做不到。

### Plugin 的生态补充

> Plugin 不是核心，但没有 Plugin 的生态是不完整的

搜索、浏览器、记忆、会议——这些靠 Plugin 补齐。

### 最优组合

```
LLM + Skills + Memory + MCP + Plugin + RAG = 真正的自主 Agent
```

缺少任何一环，Agent 都会出现明显短板。
