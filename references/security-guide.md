# MCP Server 安全指南

## 核心原则

1. **最小权限**：只授予完成任务所需的最低权限
2. **沙箱隔离**：敏感操作在容器中执行
3. **审计日志**：记录所有 MCP 调用
4. **Token 轮换**：定期更新 API Token

## 安全等级分级

### ✅ 低风险（可自由安装）
- Sequential Thinking
- Fetch
- Memory
- Time

### ⚠️ 中风险（需要配置注意）
- Filesystem（限制路径范围）
- SQLite（限制数据库）
- Browser（限制域名）

### 🔴 高风险（需要严格审查）
- GitHub（可操作仓库）
- Docker（可执行容器命令）
- Slack（可发送消息）
- Email（可发送邮件）

## 最佳实践

### 1. 路径限制
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/opt/data/workspace"]
    }
  }
}
```
只授予特定目录的访问权限。

### 2. 环境变量隔离
```bash
# 使用 .env 文件，不硬编码 Token
export GITHUB_TOKEN=$(cat ~/.tokens/github)
export BRAVE_API_KEY=$(cat ~/.tokens/brave)
```

### 3. 定期审计
```bash
# 检查已安装的 MCP Server
claude mcp list

# 检查配置文件权限
ls -la ~/.claude/settings.json
chmod 600 ~/.claude/settings.json
```

### 4. 网络隔离
- MCP Server 不应暴露到公网
- 使用 localhost 或 Unix socket
- 考虑使用 VPN 或 SSH 隧道
