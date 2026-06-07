#!/bin/bash
# Agent MCP Hub — 一键部署脚本
# 生成 MCP Server 配置，支持多种 Agent 平台

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="${SCRIPT_DIR}/configs"

echo "🔧 Agent MCP Hub — Deploy"
echo "================================"
echo ""

# 检查依赖
check_deps() {
    local missing=()
    command -v npx &>/dev/null || missing+=("npx (Node.js)")
    command -v python3 &>/dev/null || missing+=("python3")
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "⚠️  Missing dependencies: ${missing[*]}"
        echo "   Install Node.js: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
        echo "   Install Python:  sudo apt-get install -y python3 python3-pip"
        return 1
    fi
    return 0
}

# 列出可用的 MCP Server
list_servers() {
    echo "📦 Available MCP Servers:"
    echo ""
    echo "  🏗️  Infrastructure:"
    echo "    • filesystem    — Local file read/write"
    echo "    • browser       — Browser control"
    echo "    • docker        — Container management"
    echo "    • sqlite        — SQLite database"
    echo ""
    echo "  🐙 GitHub:"
    echo "    • github        — Issue/PR/Code search"
    echo "    • gh-cli        — GitHub CLI wrapper"
    echo ""
    echo "  🔍 Search & Web:"
    echo "    • brave-search  — Web search"
    echo "    • puppeteer     — Headless browser"
    echo "    • fetch         — URL content fetching"
    echo ""
    echo "  📋 Productivity:"
    echo "    • notion        — Notion read/write"
    echo "    • slack         — Slack messaging"
    echo "    • google-drive  — Google Drive"
    echo "    • linear        — Linear project management"
    echo ""
    echo "  🗄️  Database:"
    echo "    • postgres      — PostgreSQL queries"
    echo "    • redis         — Redis operations"
    echo "    • memory        — Knowledge graph memory"
    echo ""
    echo "  🤖 AI & Reasoning:"
    echo "    • sequential-thinking — Structured reasoning"
    echo "    • e2b-sandbox        — Cloud code execution"
    echo "    • firecrawl          — Web → LLM-ready data"
    echo ""
}

# 生成 Claude Desktop 配置
gen_claude_desktop() {
    local output="${1:-$HOME/.claude/settings.json}"
    cat > "$output" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/opt/data"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN_HERE"
      }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "YOUR_API_KEY_HERE"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
EOF
    echo "  ✅ Generated: $output"
}

# 生成 Claude Code MCP 配置
gen_claude_code() {
    local output="${1:-$HOME/.claude/settings.json}"
    cat > "$output" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/opt/data"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}
EOF
    echo "  ✅ Generated: $output"
}

# 生成 Hermes Agent MCP 配置
gen_hermes() {
    local output="${1:-$HOME/.hermes/config.yaml}"
    cat >> "$output" << 'EOF'

# MCP Servers (auto-configured by agent-mcp)
mcp:
  servers:
    filesystem:
      command: npx
      args: ["-y", "@modelcontextprotocol/server-filesystem", "/opt/data"]
    github:
      command: npx
      args: ["-y", "@modelcontextprotocol/server-github"]
      env:
        GITHUB_PERSONAL_ACCESS_TOKEN: YOUR_TOKEN_HERE
    brave-search:
      command: npx
      args: ["-y", "@modelcontextprotocol/server-brave-search"]
      env:
        BRAVE_API_KEY: YOUR_API_KEY_HERE
    sequential-thinking:
      command: npx
      args: ["-y", "@modelcontextprotocol/server-sequential-thinking"]
EOF
    echo "  ✅ Appended MCP config to: $output"
}

# 交互式安装
interactive_install() {
    echo "🔧 Interactive MCP Server Installation"
    echo ""
    echo "Select servers to install (comma-separated numbers):"
    echo "  1) filesystem     — File read/write"
    echo "  2) github         — GitHub operations"
    echo "  3) brave-search   — Web search"
    echo "  4) sequential-thinking — Structured reasoning"
    echo "  5) fetch          — URL content"
    echo "  6) docker         — Container management"
    echo "  7) notion         — Notion"
    echo "  8) postgres       — PostgreSQL"
    echo "  9) redis          — Redis"
    echo " 10) all — Install all of the above"
    echo ""
    read -p "Your choice: " choice
    
    # 这里只是演示，实际安装需要用户手动配置 Token
    echo ""
    echo "📝 To install, run the following commands:"
    echo ""
    
    case "$choice" in
        1|10) echo "  npx -y @modelcontextprotocol/server-filesystem /opt/data" ;;
        2|10) echo "  npx -y @modelcontextprotocol/server-github" ;;
        3|10) echo "  npx -y @modelcontextprotocol/server-brave-search" ;;
        4|10) echo "  npx -y @modelcontextprotocol/server-sequential-thinking" ;;
        5|10) echo "  npx -y @modelcontextprotocol/server-fetch" ;;
        6|10) echo "  npx -y @modelcontextprotocol/server-docker" ;;
        7|10) echo "  npx -y @modelcontextprotocol/server-notion" ;;
        8|10) echo "  npx -y @modelcontextprotocol/server-postgres" ;;
        9|10) echo "  npx -y @modelcontextprotocol/server-redis" ;;
    esac
    
    echo ""
    echo "⚠️  Remember to set environment variables for API tokens!"
}

# 主流程
list_servers
echo "================================"
echo ""
echo "📋 Select configuration to generate:"
echo "  1) Claude Desktop"
echo "  2) Claude Code"
echo "  3) Hermes Agent"
echo "  4) Interactive install guide"
echo "  5) All configs"
echo ""
read -p "Your choice [5]: " config_choice
config_choice=${config_choice:-5}

case "$config_choice" in
    1) gen_claude_desktop ;;
    2) gen_claude_code ;;
    3) gen_hermes ;;
    4) interactive_install ;;
    5)
        gen_claude_desktop
        gen_claude_code
        gen_hermes
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✅ Done! MCP configs generated."
echo ""
echo "📊 三层能力模型:"
echo "  Skills (大脑经验) → https://github.com/kongjie0325-art/agent-skills"
echo "  MCP   (手和脚)   → 已配置 ✅"
echo "  Plugin (特殊工具) → https://github.com/kongjie0325-art/agent-plugins"
