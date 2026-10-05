# claude-statusline

Статусная строка Claude Code на [ccstatusline](https://github.com/sirmalloc/ccstatusline):

```
Model: Opus 5.5 | Ctx Used: 23.0% | 5h left: 71.0% | Week left: 58.0% | Thinking: high
```

модель · заполненность контекста · остаток 5-часового и недельного лимита · уровень thinking.

## Установка

Нужен Node.js (`brew install node`).

```bash
git clone git@github.com:deimos-deimos/claude-statusline.git ~/repos/claude-statusline
~/repos/claude-statusline/install.sh
```

Скрипт:
1. ставит `ccstatusline@2.2.29` глобально из публичного npm (`--registry https://registry.npmjs.org`, чтобы не упереться в корпоративный `~/.npmrc`);
2. копирует `ccstatusline.json` в `~/.config/ccstatusline/settings.json`;
3. прописывает `statusLine` в `~/.claude/settings.json` абсолютным путём к бинарю, не трогая остальные ключи.

Старые файлы сохраняются как `*.bak.<timestamp>`. Другая версия: `CCSTATUSLINE_VERSION=x.y.z ./install.sh`.

## Правка

Конфиг — `ccstatusline.json` (`lines` = строки из виджетов). Полезные ключи:
- `session-usage` / `weekly-usage`: `metadata.invert: "true"` — показывать остаток; `metadata.display: time|progress|slider`.
- `context-percentage`: `metadata.inverse: "true"` — остаток контекста.
- `rawValue: true` — без встроенной подписи; `merge: true` — склеить с соседним виджетом.

Интерактивно: запустить `ccstatusline` без stdin (TUI). Если он предложит «Install» — отказаться, команда уже прописана. После правки скопировать `~/.config/ccstatusline/settings.json` обратно в репо.

Проверка рендера без Claude Code: `ccstatusline < sample.json` (пример входа Claude Code; `resets_at` — unix-секунды).

Лимиты берутся из stdin Claude Code (`rate_limits`), недостающее — из `api.anthropic.com/api/oauth/usage` по OAuth-токену Claude Code (кэш 180 с в `~/.cache/ccstatusline/`).
