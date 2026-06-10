# Claude Code + DeepSeek 一键部署

🔥 国内用户无需海外信用卡 | **Windows 双击 / Mac 一行命令** | 5 分钟搞定 | 费用降低 90%

不需要 Anthropic 账号，不需要海外支付，一行命令启动 Claude Code。

---

## 快速开始

### Windows
右键 `setup_claude_deepseek.bat` → **以管理员身份运行**，跟着提示输入 DeepSeek API Key 即可。

### Mac
```bash
curl -sL https://raw.githubusercontent.com/shusheng-crypto/claude-code-deepseek-setup/main/install.sh | bash
```

> 上面这行命令复制粘贴到终端回车即可，脚本会自动完成全部配置。

### 就是这么简单
```
Windows → 双击 .bat 文件
Mac     → 粘贴一行命令回车
之后   → 输入 claude 启动
```

## 这是什么？

Claude Code 是 Anthropic 官方的 AI 编程助手（终端版），默认需要 Anthropic 的 API Key 和海外支付方式。

**这个脚本解决了国内用户的两个核心痛点：**

1. **无需海外信用卡** — 通过环境变量把 Claude Code 的后端切换到 DeepSeek
2. **5 分钟一键部署** — 自动安装 Node.js、安装 Claude Code CLI、配置环境变量

## 原理

```
Claude Code CLI 默认连接 Anthropic API
         ↓
通过环境变量将请求指向 DeepSeek 的 Anthropic 兼容端点：

  ANTHROPIC_BASE_URL = https://api.deepseek.com/anthropic
  ANTHROPIC_AUTH_TOKEN = 你的 DeepSeek API Key
  ANTHROPIC_MODEL = deepseek-chat / deepseek-reasoner
```

同时设置 DeepSeek 和 OpenAI 兼容变量，方便其他 AI 工具直接使用。

## 功能

- ✅ 自动检测并安装 Node.js LTS
- ✅ 一键安装 `@anthropic-ai/claude-code`
- ✅ 配置 DeepSeek 后端（国内直连）
- ✅ 支持 `deepseek-chat` / `deepseek-reasoner` 模型
- ✅ 自动清理冲突的 ANTHROPIC_API_KEY
- ✅ 国内/海外 npm 源智能切换（默认 npmmirror）
- ✅ 管理员权限检测（无权限也可继续）

## 费用对比

| | Anthropic 官方 | DeepSeek |
|:---|:------------:|:--------:|
| Claude Code 订阅 | $20/月 | **免费** |
| API 费用 | 按量计费（贵） | 约 1/10 |
| 国内支付 | ❌ 需要海外卡 | ✅ 支付宝 |
| 速度 | ❌ 海外延迟高 | ✅ 国内 <50ms |

## 使用方法

1. 运行脚本，自动安装 Node.js 和 Claude Code
2. 输入你的 DeepSeek API Key（[点此获取](https://platform.deepseek.com)）
3. 选择模型（deepseek-chat 或 deepseek-reasoner）
4. 关闭当前命令行，重新打开
5. 输入 `claude` 启动

### 环境变量说明

脚本会设置以下环境变量（用户级）：

| 变量 | 值 | 用途 |
|:----|:---|:-----|
| `ANTHROPIC_BASE_URL` | `https://api.deepseek.com/anthropic` | Claude Code 后端地址 |
| `ANTHROPIC_AUTH_TOKEN` | 你的 DeepSeek API Key | 认证令牌 |
| `ANTHROPIC_MODEL` | deepseek-chat / deepseek-reasoner | 主模型 |
| `ANTHROPIC_SMALL_FAST_MODEL` | deepseek-chat | 快速小任务 |
| `OPENAI_BASE_URL` | `https://api.deepseek.com/v1` | OpenAI 兼容接口 |
| `OPENAI_API_KEY` | 你的 DeepSeek API Key | OpenAI 兼容认证 |
| `DEEPSEEK_API_KEY` | 你的 DeepSeek API Key | DeepSeek 直连 |

## 常见问题

**Q: 运行后没有反应？**
A: 右键脚本 → 属性 → 如果有"解除锁定"，勾上。或者以管理员身份运行 CMD，然后拖入脚本回车。

**Q: 提示 Node.js 未安装？**
A: 脚本会自动安装。如果失败，请手动从 [nodejs.org](https://nodejs.org) 下载 LTS 版本安装。

**Q: DeepSeek API Key 怎么获取？**
A: 访问 [platform.deepseek.com](https://platform.deepseek.com) 注册 → 创建 API Key → 充值（50 元够用很久）。

**Q: 需要科学上网吗？**
A: 不需要。DeepSeek 国内直连，速度比 Anthropic 官方快 10 倍。

## Star History

如果这个项目对你有帮助，请点一个 ⭐ Star，让更多国内开发者看到。

## License

MIT
