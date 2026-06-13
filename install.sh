#!/bin/bash
set -e

echo "======================================"
echo "  Claude Code + DeepSeek 安装 (Mac)"
echo "======================================"
echo ""

LOG="$HOME/claude_deepseek_install.log"
echo "[$(date)] script started" > "$LOG"

# 检查 Node，没有就自动下载安装官方 pkg
if ! command -v node >/dev/null 2>&1; then
  echo "未检测到 Node.js，正在自动下载安装..."
  echo "[$(date)] node not found, auto-installing" >> "$LOG"

  ARCH=$(uname -m)
  if [ "$ARCH" = "arm64" ]; then
    NODE_PKG="node-v20.18.0.pkg"
    NODE_URL="https://nodejs.org/dist/v20.18.0/node-v20.18.0.pkg"
  else
    NODE_PKG="node-v20.18.0.pkg"
    NODE_URL="https://nodejs.org/dist/v20.18.0/node-v20.18.0.pkg"
  fi

  echo "正在下载 Node.js 安装包（约 70MB，请稍候）..."
  if curl -fL "$NODE_URL" -o "/tmp/$NODE_PKG"; then
    echo "下载完成，开始安装（需要输入开机密码）..."
    if sudo installer -pkg "/tmp/$NODE_PKG" -target /; then
      echo "✓ Node.js 安装完成"
      echo "[$(date)] node installed" >> "$LOG"
      export PATH="/usr/local/bin:$PATH"
      hash -r
    else
      echo "❌ Node.js 安装失败，请手动到 https://nodejs.org 下载 LTS 安装。"
      echo "[$(date)] node install FAILED" >> "$LOG"
      exit 1
    fi
  else
    echo "❌ 下载失败（可能网络问题），请手动到 https://nodejs.org 下载 LTS 安装。"
    echo "[$(date)] node download FAILED" >> "$LOG"
    exit 1
  fi
else
  echo "✓ Node.js 已安装 ($(node -v))"
  echo "[$(date)] node $(node -v)" >> "$LOG"
fi

# 检查 npm
if ! command -v npm >/dev/null 2>&1; then
  echo "❌ 未检测到 npm，请重装 Node.js LTS。"
  echo "[$(date)] npm not found" >> "$LOG"
  exit 1
fi
echo "✓ npm 已安装 ($(npm -v))"
echo "[$(date)] npm $(npm -v)" >> "$LOG"
echo ""

# 安装 Claude Code（普通安装失败则自动用 sudo）
echo "正在安装 Claude Code..."
echo "[$(date)] installing claude code" >> "$LOG"
if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
  echo "✓ Claude Code 安装完成"
  echo "[$(date)] npm install OK" >> "$LOG"
elif sudo npm install -g @anthropic-ai/claude-code; then
  echo "✓ Claude Code 安装完成（已用管理员权限）"
  echo "[$(date)] npm install OK with sudo" >> "$LOG"
else
  echo "❌ 安装失败，请手动执行： sudo npm install -g @anthropic-ai/claude-code"
  echo "[$(date)] npm install FAILED" >> "$LOG"
  exit 1
fi

# 验证 claude 命令可用
if ! command -v claude >/dev/null 2>&1; then
  echo "⚠️  claude 命令暂时找不到，请关闭终端重新打开后再试 claude --version"
  echo "[$(date)] claude cmd not found" >> "$LOG"
else
  echo "✓ claude 命令可用 ($(claude --version 2>/dev/null))"
  echo "[$(date)] claude OK" >> "$LOG"
fi
echo ""

# 输入 Key
read -rsp "请粘贴 DeepSeek API Key (sk-开头): " USER_KEY
echo ""
if [ -z "$USER_KEY" ]; then
  echo "❌ API Key 不能为空"
  echo "[$(date)] empty key" >> "$LOG"
  exit 1
fi

# 选择模型
echo ""
echo "请选择默认模型："
echo "  1 - flash（默认，快，日常用）"
echo "  2 - pro（强，写代码用）"
read -rp "请输入 1 或 2，直接回车默认 1: " MODEL_CHOICE
if [ "$MODEL_CHOICE" = "2" ]; then
  MODEL="deepseek-v4-pro"
else
  MODEL="deepseek-v4-flash"
fi
echo "✓ 已选择：$MODEL"
echo "[$(date)] model $MODEL" >> "$LOG"

# 写配置
mkdir -p "$HOME/.claude"
if [ -f "$HOME/.claude/settings.json" ]; then
  cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.bak.$(date +%Y%m%d%H%M%S)"
  echo "✓ 已备份旧配置"
  echo "[$(date)] settings backup" >> "$LOG"
fi

cat > "$HOME/.claude/settings.json" << EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "$USER_KEY",
    "ANTHROPIC_MODEL": "$MODEL",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-flash",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  }
}
EOF

echo "✓ 配置已写入 $HOME/.claude/settings.json"
echo "[$(date)] settings written, done" >> "$LOG"
echo ""
echo "======================================"
echo "  ✅ 完成! 输入 claude 启动"
echo "  写代码切 pro： /model opus"
echo "  日常切 flash： /model sonnet"
echo "======================================"
