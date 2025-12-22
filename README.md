# Dotfiles - AI Development Environment

> Prometheus v5.1 配置同步仓库

## 📁 结构

```
dotfiles/
├── codex/              # OpenAI Codex 配置
│   ├── AGENTS.md       # 主配置
│   ├── CLAUDE.md       # Claude 兼容配置
│   ├── prompts/        # 提示词
│   ├── skills/         # Skills
│   └── rules/          # 规则
├── claude/             # Claude Code 配置
│   ├── CLAUDE.md       # 主配置
│   ├── commands/       # 命令
│   └── skills/         # Skills
├── config/             # 配置模板（含敏感信息）
│   └── codex-config.toml.template
└── scripts/
    ├── install.sh      # 安装脚本
    └── sync.sh         # 同步脚本
```

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. 安装配置

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

### 3. 配置敏感信息

```bash
# 复制模板并填入你的 API keys
cp config/codex-config.toml.template ~/.codex/config.toml
# 编辑填入实际值
vim ~/.codex/config.toml
```

## 🔄 同步

### 手动同步

```bash
./scripts/sync.sh
```

### 自动同步（macOS）

安装脚本会自动配置每小时同步的 launchd 任务。

查看状态：
```bash
launchctl list | grep dotfiles
```

禁用自动同步：
```bash
launchctl unload ~/Library/LaunchAgents/com.dotfiles.sync.plist
```

## ⚠️ 注意事项

1. **敏感信息**: `config.toml` 和 `auth.json` 不会被同步，需要手动配置
2. **首次使用**: 安装后需要重启 Codex/Claude Code 加载新配置
3. **冲突处理**: 安装脚本会备份现有配置到 `~/.dotfiles-backup/`

## 📝 配置说明

### Codex Skills

| Skill | 用途 |
|-------|------|
| `prometheus-core` | C.O.D.E 工作流 |
| `prometheus-aether-ui` | Liquid Glass UI 美学 |
| `prometheus-debug` | 调试协议 |
| `prometheus-tooling` | 工具降级策略 |

### 启用 Skills

在 `~/.codex/config.toml` 中添加：
```toml
[features]
skills = true
```

