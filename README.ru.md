# claude-statusline

[English](README.md) · **Русский** · [中文](README.zh.md)

Готовая статусная строка для [Claude Code](https://code.claude.com) на основе [ccstatusline](https://github.com/sirmalloc/ccstatusline):

```
Model: Opus 5.5 | Ctx Used: 23.0% | 5h left: 71.0% | Week left: 58.0% | Thinking: high
```

Модель · заполненность контекста · остаток 5-часового и недельного лимита · уровень thinking.

## Установка

Нужны macOS или Linux и Node.js (`brew install node` или пакетный менеджер дистрибутива).

```bash
git clone https://github.com/deimos-deimos/claude-statusline.git ~/claude-statusline
~/claude-statusline/install.sh
```

Затем перезапустите Claude Code.

Скрипт:
1. ставит `ccstatusline@2.2.29` глобально из публичного npm (`--registry https://registry.npmjs.org`, чтобы не мешал свой реестр в `~/.npmrc`);
2. копирует `ccstatusline.json` в `~/.config/ccstatusline/settings.json`;
3. прописывает `statusLine` в `~/.claude/settings.json` абсолютным путём к бинарю, не трогая остальные ключи.

Старые файлы сохраняются как `*.bak.<timestamp>`. Другая версия: `CCSTATUSLINE_VERSION=x.y.z ./install.sh`.

## Настройка

Конфиг виджетов — `ccstatusline.json` (`lines` — массив строк, каждая — список виджетов). Полезные ключи:
- `session-usage` / `weekly-usage`: `metadata.invert: "true"` — показывать остаток вместо израсходованного; `metadata.display: time|progress|slider`.
- `context-percentage`: `metadata.inverse: "true"` — остаток контекста.
- `rawValue: true` — без встроенной подписи; `merge: true` — склеить с соседним виджетом без разделителя.

Интерактивный редактор: запустить `ccstatusline` без stdin (TUI). Если он предложит «Install» — откажитесь, команда уже прописана. После правки скопируйте `~/.config/ccstatusline/settings.json` обратно в репозиторий.

Проверка без Claude Code: `ccstatusline < sample.json` (пример входных данных статусной строки; `resets_at` — unix-секунды).

Лимиты берутся из stdin Claude Code (`rate_limits`), недостающее — из `api.anthropic.com/api/oauth/usage` по OAuth-токену Claude Code (кэш 180 с в `~/.cache/ccstatusline/`).
