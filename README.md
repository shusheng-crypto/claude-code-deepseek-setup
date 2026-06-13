# Claude Code + DeepSeek 一键部署

🔥 国内用户无需海外信用卡 | **Windows 双击 / Mac 一行命令** | 5 分钟搞定 | 费用降低 90%

不需要 Anthropic 账号，不需要海外支付，一行命令启动 Claude Code。

---

## 快速开始

### Windows
右键 `setup_claude_deepseek.bat` → **以管理员身份运行**，跟着提示输入 DeepSeek API Key 即可。

### Mac
```bash
curl -sL https://raw.githubusercontent.com/shusheng-crypto/claude-code-deepseek-setup/main/install.sh -o ~/install.sh && bash ~/install.sh
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
通过 Claude Code 的 settings.json 配置文件将请求指向 DeepSeek 的 Anthropic 兼容端点：

  ANTHROPIC_BASE_URL = https://api.deepseek.com/anthropic
  ANTHROPIC_AUTH_TOKEN = 你的 DeepSeek API Key
  ANTHROPIC_MODEL = deepseek-v4-pro / deepseek-v4-flash
```

配置即生效，无需重启终端。

## 功能

- ✅ 自动检测并安装 Node.js LTS
- ✅ 一键安装 `@anthropic-ai/claude-code`
- ✅ 配置 DeepSeek 后端（国内直连）
- ✅ 支持 `deepseek-v4-pro` / `deepseek-v4-flash` 模型
- ✅ 支持 /model opus|sonnet|haiku 切换
- ✅ 权限不足时自动 sudo 回退
- ✅ 关闭非必要遥测流量

## 费用对比

| | Anthropic 官方 | DeepSeek |
|:---|:------------:|:--------:|
| Claude Code | 需订阅或 API Key | **免费（自带 Key）** |
| API 费用 | 按量计费（贵） | 约 1/10 |
| 国内支付 | ❌ 需要海外卡 | ✅ 支付宝 |
| 速度 | ❌ 海外延迟高 | ✅ 国内直连 |

## 使用方法

1. 运行脚本，自动检测/安装 Node.js 和 Claude Code
2. 输入你的 DeepSeek API Key（[点此获取](https://platform.deepseek.com)）
3. 选择模型（flash 日常用 / pro 写代码用）
4. 输入 `claude` 启动

### 环境变量说明

脚本会设置以下环境变量（用户级）：

| 变量 | 值 | 用途 |
|:----|:---|:-----|
| `ANTHROPIC_BASE_URL` | `https://api.deepseek.com/anthropic` | Claude Code 后端地址 |
| `ANTHROPIC_AUTH_TOKEN` | 你的 DeepSeek API Key | 认证令牌 |
| `ANTHROPIC_MODEL` | deepseek-v4-pro / deepseek-v4-flash | 主模型 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | deepseek-v4-pro | /model opus 对应模型 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | deepseek-v4-flash | /model sonnet 对应模型 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | deepseek-v4-flash | /model haiku 对应模型 |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | 1 | 关闭非必要流量 |

## 常见问题

**Q: 运行后报 syntax error 或输入跳过？**
A: 不要用 `curl ... | bash` 管道方式。用 README 里的完整命令（带 `-o ~/install.sh && bash ~/install.sh`），先下载到本地再运行。

**Q: 提示 Node.js 未安装？**
A: 脚本会自动下载安装。如果下载失败（网络问题），请手动从 [nodejs.org](https://nodejs.org) 下载 LTS 版本安装。

**Q: DeepSeek API Key 怎么获取？**
A: 访问 [platform.deepseek.com](https://platform.deepseek.com) 注册 → 创建 API Key → 充值（50 元够用很久）。

**Q: 需要科学上网吗？**
A: 不需要。DeepSeek 国内直连，速度比 Anthropic 官方快 10 倍。

## Star History

如果这个项目对你有帮助，请点一个 ⭐ Star，让更多国内开发者看到。

## License

MIT
