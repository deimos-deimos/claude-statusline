# claude-statusline

**English** · [Русский](README.ru.md) · [中文](README.zh.md)

A ready-to-use [Claude Code](https://code.claude.com) status line built on [ccstatusline](https://github.com/sirmalloc/ccstatusline):

```
Model: Opus 5.5 | Ctx Used: 23.0% | 5h left: 71.0% | Week left: 58.0% | Thinking: high
```

Model · context window usage · remaining 5-hour and weekly limits · thinking effort level.

## Install

Requirements: macOS or Linux, Node.js (`brew install node` or your package manager).

```bash
git clone https://github.com/deimos-deimos/claude-statusline.git ~/claude-statusline
~/claude-statusline/install.sh
```

Then restart Claude Code.

The script:
1. installs `ccstatusline@2.2.29` globally from the public npm registry (`--registry https://registry.npmjs.org`, so a custom registry in `~/.npmrc` doesn't get in the way);
2. copies `ccstatusline.json` to `~/.config/ccstatusline/settings.json`;
3. sets `statusLine` in `~/.claude/settings.json` to the absolute path of the binary, leaving all other keys untouched.

Existing files are backed up as `*.bak.<timestamp>`. To pin a different version: `CCSTATUSLINE_VERSION=x.y.z ./install.sh`.

## Customize

The widget config is `ccstatusline.json` (`lines` is an array of lines, each a list of widgets). Useful keys:
- `session-usage` / `weekly-usage`: `metadata.invert: "true"` shows what's left instead of what's used; `metadata.display: time|progress|slider`.
- `context-percentage`: `metadata.inverse: "true"` shows remaining context.
- `rawValue: true` hides the built-in label; `merge: true` joins a widget to its neighbor without a separator.

Interactive editor: run `ccstatusline` without stdin to open the TUI. If it offers to "Install", decline — the command is already configured. Copy `~/.config/ccstatusline/settings.json` back into the repo afterwards to keep your changes.

Preview without Claude Code: `ccstatusline < sample.json` (a sample of Claude Code's status line input; `resets_at` is in unix seconds).

Limits come from Claude Code's stdin (`rate_limits`); anything missing is fetched from `api.anthropic.com/api/oauth/usage` using Claude Code's OAuth token (cached for 180 s in `~/.cache/ccstatusline/`).
