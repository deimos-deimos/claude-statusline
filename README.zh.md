# claude-statusline

[English](README.md) · [Русский](README.ru.md) · **中文**

基于 [ccstatusline](https://github.com/sirmalloc/ccstatusline) 的 [Claude Code](https://code.claude.com) 开箱即用状态栏：

```
Model: Opus 5.5 | Ctx Used: 23.0% | 5h left: 71.0% | Week left: 58.0% | Thinking: high
```

模型 · 上下文窗口占用 · 5 小时与每周额度剩余 · 思考强度（thinking effort）。

## 安装

环境要求：macOS 或 Linux，Node.js（`brew install node` 或系统包管理器）。

```bash
git clone https://github.com/deimos-deimos/claude-statusline.git ~/claude-statusline
~/claude-statusline/install.sh
```

然后重启 Claude Code。

脚本会：
1. 从公共 npm 源全局安装 `ccstatusline@2.2.29`（`--registry https://registry.npmjs.org`，避免受 `~/.npmrc` 中自定义源的影响）；
2. 将 `ccstatusline.json` 复制到 `~/.config/ccstatusline/settings.json`；
3. 在 `~/.claude/settings.json` 中写入 `statusLine`（使用可执行文件的绝对路径），其他配置项保持不变。

已有文件会备份为 `*.bak.<timestamp>`。安装其他版本：`CCSTATUSLINE_VERSION=x.y.z ./install.sh`。

## 自定义

组件配置文件为 `ccstatusline.json`（`lines` 是行的数组，每行是一组组件）。常用字段：
- `session-usage` / `weekly-usage`：`metadata.invert: "true"` 显示剩余量而非已用量；`metadata.display: time|progress|slider`。
- `context-percentage`：`metadata.inverse: "true"` 显示剩余上下文。
- `rawValue: true` 隐藏内置标签；`merge: true` 与相邻组件无分隔符拼接。

交互式编辑：不带 stdin 直接运行 `ccstatusline` 打开 TUI。如果提示 “Install”，请选择拒绝——命令已配置好。修改后把 `~/.config/ccstatusline/settings.json` 复制回仓库以保存改动。

脱离 Claude Code 预览：`ccstatusline < sample.json`（Claude Code 状态栏输入示例；`resets_at` 为 Unix 秒）。

额度数据来自 Claude Code 的 stdin（`rate_limits`），缺失部分通过 Claude Code 的 OAuth 令牌从 `api.anthropic.com/api/oauth/usage` 获取（在 `~/.cache/ccstatusline/` 缓存 180 秒）。
