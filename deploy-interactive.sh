#!/usr/bin/env bash
# Запуск: ./deploy-interactive.sh
# Запросит токен скрыто (не светится на экране), положит в CLOUDFLARE_API_TOKEN и вызовет deploy-cloudflare.sh.
# Не клади токен в чат — только сюда, в терминал.

set -euo pipefail
cd "$(dirname "$0")"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "Вставь API-токен Cloudflare (одна строка, только cfut_…), затем Enter:" >&2
  read -r CLOUDFLARE_API_TOKEN
  export CLOUDFLARE_API_TOKEN
fi

exec ./deploy-cloudflare.sh
