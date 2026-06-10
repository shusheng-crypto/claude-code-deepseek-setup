#!/bin/bash
# Claude Code + DeepSeek 一键部署脚本 (Mac/Linux)
set -e

echo ""
echo "============================================================"
echo "  Claude Code + DeepSeek 一键部署"
echo "  国内用户无需海外信用卡 | 5分钟搞定"
echo "============================================================"
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "[安装] Node.js..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install node
    else
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
fi

echo "[完成] Node.js $(node -v)"

# 安装 Claude Code
if ! command -v claude &> /dev/null; then
    echo "[安装] Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com
fi

echo "[完成] Claude Code $(claude --version 2>/dev/null || echo '已安装')"

# 配置环境变量
echo ""
echo "[配置] DeepSeek 环境变量..."
read -p "请输入你的 DeepSeek API Key (sk-开头): " DEEPSEEK_KEY
if [ -z "$DEEPSEEK_KEY" ]; then
    echo "错误: API Key 不能为空"
    exit 1
fi

echo ""
echo "选择模型:"
echo "  1 - deepseek-chat (默认，速度快)"
echo "  2 - deepseek-reasoner (推理更强)"
read -p "请选择 (1/2): " MODEL_CHOICE
if [ "$MODEL_CHOICE" = "2" ]; then
    DEEPSEEK_MODEL="deepseek-reasoner"
else
    DEEPSEEK_MODEL="deepseek-chat"
fi

# 写入 shell 配置文件
if [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE="$HOME/.zshrc"
else
    PROFILE="$HOME/.bashrc"
fi

cat >> "$PROFILE" << EOF

# Claude Code + DeepSeek 配置
export ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
export ANTHROPIC_AUTH_TOKEN="$DEEPSEEK_KEY"
export ANTHROPIC_MODEL="$DEEPSEEK_MODEL"
export ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat"
export OPENAI_BASE_URL="https://api.deepseek.com/v1"
export OPENAI_API_KEY="$DEEPSEEK_KEY"
export DEEPSEEK_API_KEY="$DEEPSEEK_KEY"
EOF

echo ""
echo "[完成] 环境变量已配置！"
echo ""
echo "请执行以下命令使配置生效:"
echo "  source $PROFILE"
echo ""
echo "然后运行:"
echo "  claude"
echo ""
