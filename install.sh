#!/usr/bin/env bash
# Ставит ccstatusline и раскатывает конфиг статусной строки Claude Code.
# Повторный запуск безопасен: существующие файлы бэкапятся в *.bak.<timestamp>.
set -euo pipefail

VERSION="${CCSTATUSLINE_VERSION:-2.2.29}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ccstatusline"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
TS="$(date +%Y%m%d%H%M%S)"

command -v npm >/dev/null || { echo "npm не найден — поставьте Node.js (brew install node)" >&2; exit 1; }

# 1. ccstatusline из публичного npm (на случай корпоративного ~/.npmrc)
if [ "$(ccstatusline --version 2>/dev/null || true)" != "$VERSION" ]; then
  echo "→ npm install -g ccstatusline@$VERSION"
  npm install -g "ccstatusline@$VERSION" --registry https://registry.npmjs.org
fi
BIN="$(command -v ccstatusline)"
echo "✓ ccstatusline $("$BIN" --version) → $BIN"

# 2. Конфиг виджетов
mkdir -p "$CFG_DIR"
if [ -f "$CFG_DIR/settings.json" ] && ! cmp -s "$REPO_DIR/ccstatusline.json" "$CFG_DIR/settings.json"; then
  cp "$CFG_DIR/settings.json" "$CFG_DIR/settings.json.bak.$TS"
  echo "  бэкап: $CFG_DIR/settings.json.bak.$TS"
fi
cp "$REPO_DIR/ccstatusline.json" "$CFG_DIR/settings.json"
echo "✓ конфиг → $CFG_DIR/settings.json"

# 3. statusLine в ~/.claude/settings.json (остальные ключи не трогаем)
mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak.$TS"
BIN="$BIN" node -e '
  const fs = require("fs"), p = process.argv[1];
  const s = JSON.parse(fs.readFileSync(p, "utf8"));
  s.statusLine = { type: "command", command: process.env.BIN, padding: 0 };
  fs.writeFileSync(p, JSON.stringify(s, null, 2) + "\n");
' "$CLAUDE_SETTINGS"
echo "✓ statusLine → $CLAUDE_SETTINGS (бэкап: $CLAUDE_SETTINGS.bak.$TS)"

echo "Готово. Перезапустите Claude Code."
