#!/bin/bash
set -e

echo "======================================"
echo "  Claude Code + DeepSeek 安装 (Mac)"
echo "======================================"
echo ""

# 日志
LOG="$HOME/claude_deepseek_install.log"
echo "[$(date)] script started" > "$LOG"

# 检查 Node
if ! command -v node >/dev/null 2>&1; then
  echo "❌ 未检测到 Node.js"
  echo "请先到 https://nodejs.org 下载 LTS 安装包，双击安装后再运行本脚本。"
  echo "[$(date)] node not found" >> "$LOG"
  exit 1
fi

echo "✓ Node.js 已安装 ($(node -v))"
echo "[$(date)] node: $(node -v)" >> "$LOG"
echo ""

# 检查 npm
if ! command -v npm >/dev/null 2>&1; then
  echo "❌ 未检测到 npm"
  echo "请重新安装 Node.js LTS 后再运行本脚本。"
  echo "[$(date)] npm not found" >> "$LOG"
  exit 1
fi

echo "✓ npm 已安装 ($(npm -v))"
echo "[$(date)] npm: $(npm -v)" >> "$LOG"
echo ""

# 安装 Claude Code
echo "正在安装 Claude Code（若已安装会自动更新）..."
echo "[$(date)] installing claude code" >> "$LOG"

if npm install -g @anthropic-ai/claude-code; then
  echo "✓ Claude Code 安装完成"
  echo "[$(date)] npm install claude OK" >> "$LOG"
else
  echo ""
  echo "❌ Claude Code 安装失败，可能是 npm 全局权限不足。"
  echo "可以尝试手动执行："
  echo ""
  echo "  sudo npm install -g @anthropic-ai/claude-code"
  echo ""
  echo "然后重新运行本脚本。"
  echo "[$(date)] npm install claude FAILED" >> "$LOG"
  exit 1
fi

echo ""

# 检查 claude 命令
if ! command -v claude >/dev/null 2>&1; then
  echo "⚠️ Claude Code 可能已安装，但当前终端找不到 claude 命令。"
  echo "请关闭终端重新打开后输入："
  echo ""
  echo "  claude --version"
  echo ""
  echo "如果仍找不到，请把日志发给我们："
  echo "  $LOG"
  echo "[$(date)] claude command not found after install" >> "$LOG"
else
  echo "✓ claude 命令可用：$(claude --version 2>/dev/null || echo 已安装)"
  echo "[$(date)] claude found: $(command -v claude)" >> "$LOG"
fi

echo ""

# 输入 Key
read -rsp "请粘贴 DeepSeek API Key (sk-开头): " USER_KEY
echo ""

if [ -z "$USER_KEY" ]; then
  echo "❌ API Key 不能为空"
  echo "[$(date)] empty api key" >> "$LOG"
  exit 1
fi

# 选择模型
echo ""
echo "请选择模型："
echo "  1 - deepseek-chat（默认，速度快，日常推荐）"
echo "  2 - deepseek-reasoner（推理强，复杂任务使用）"
echo ""
read -rp "请输入 1 或 2，直接回车默认 1: " MODEL_CHOICE

if [ "$MODEL_CHOICE" = "2" ]; then
  MODEL="deepseek-reasoner"
else
  MODEL="deepseek-chat"
fi

echo "✓ 已选择模型：$MODEL"
echo "[$(date)] model: $MODEL" >> "$LOG"

# 创建 Claude 配置目录
mkdir -p "$HOME/.claude"

# 备份旧 settings.json
if [ -f "$HOME/.claude/settings.json" ]; then
  cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.bak.$(date +%Y%m%d%H%M%S)"
  echo "✓ 已备份旧配置文件"
  echo "[$(date)] settings backup created" >> "$LOG"
fi

# 写入 Claude settings.json
cat > "$HOME/.claude/settings.json" << EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "$USER_KEY",
    "ANTHROPIC_MODEL": "$MODEL",
    "ANTHROPIC_SMALL_FAST_MODEL": "deepseek-chat",
    "OPENAI_BASE_URL": "https://api.deepseek.com/v1",
    "OPENAI_API_KEY": "$USER_KEY",
    "DEEPSEEK_API_KEY": "$USER_KEY"
  },
  "model": "$MODEL"
}
EOF

echo "✓ 已写入 Claude 配置：$HOME/.claude/settings.json"
echo "[$(date)] settings.json written" >> "$LOG"

# 同时写入 ~/.zshrc，保证新终端环境变量可用
ZSHRC="$HOME/.zshrc"

# 删除旧的本脚本写入块
if [ -f "$ZSHRC" ]; then
  sed -i.bak '/# >>> claude-deepseek-env >>>/,/# <<< claude-deepseek-env <<</d' "$ZSHRC"
fi

cat >> "$ZSHRC" << EOF

# >>> claude-deepseek-env >>>
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="$USER_KEY"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat"
export OPENAI_BASE_URL="https://api.deepseek.com/v1"
export OPENAI_API_KEY="$USER_KEY"
export DEEPSEEK_API_KEY="$USER_KEY"
unset ANTHROPIC_API_KEY
# <<< claude-deepseek-env <<<
EOF

echo "✓ 已写入环境变量到：$ZSHRC"
echo "[$(date)] zshrc env written" >> "$LOG"

echo ""
echo "======================================"
echo "  ✅ 全部完成!"
echo ""
echo "  配置文件:"
echo "    $HOME/.claude/settings.json"
echo ""
echo "  日志文件:"
echo "    $LOG"
echo ""
echo "  下一步："
echo "    1. 关闭当前终端"
echo "    2. 重新打开终端"
echo "    3. 输入："
echo ""
echo "       claude"
echo ""
echo "======================================"
