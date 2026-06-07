# MCP Server 目录

## 安装方式

### 方式一：npx（推荐，无需安装）
```bash
# 基础设施
npx -y @modelcontextprotocol/server-filesystem /opt/data
npx -y @modelcontextprotocol/server-browser
npx -y @modelcontextprotocol/server-docker

# GitHub
npx -y @modelcontextprotocol/server-github

# 搜索
npx -y @modelcontextprotocol/server-brave-search

# 推理
npx -y @modelcontextprotocol/server-sequential-thinking

# 网页抓取
npx -y @modelcontextprotocol/server-fetch
```

### 方式二：Docker
```bash
docker run -d \
  --name mcp-filesystem \
  -v /opt/data:/workspace \
  ghcr.io/modelcontextprotocol/server-filesystem /workspace
```

### 方式三：Claude Desktop 配置
复制 configs/claude_desktop.json 的内容到 ~/.claude/settings.json

## Server 清单详见 README.md
