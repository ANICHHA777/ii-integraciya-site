#!/usr/bin/env bash
# Деплой в Cloudflare Pages (CDN = быстрая отдача по всему миру).
# Нужен API token: https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
# Права: User — User Details — Read; Account — Cloudflare Pages — Edit; Account — Account Settings — Read
#
# Скрипт сам снимает типичные PROXY-* переменные — иначе Wrangler часто даёт «Proxy response 403».

set -euo pipefail
cd "$(dirname "$0")"

unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy || true

# Токен: либо в окружении, либо файл ВНЕ этой папки (Wrangler читает --env-file сам; не клади секреты в каталог деплоя).
WRANGLER_ENV_ARGS=()
if [[ -n "${CLOUDFLARE_ENV_FILE:-}" && -f "${CLOUDFLARE_ENV_FILE}" ]]; then
  WRANGLER_ENV_ARGS+=(--env-file "${CLOUDFLARE_ENV_FILE}")
fi
if [[ -z "${CLOUDFLARE_API_TOKEN:-}" && ${#WRANGLER_ENV_ARGS[@]} -eq 0 ]]; then
  echo "Задай CLOUDFLARE_API_TOKEN в окружении или CLOUDFLARE_ENV_FILE=путь/к/файлу с CLOUDFLARE_API_TOKEN=… (см. DEPLOY.md)." >&2
  exit 1
fi

if [[ ! -f index.html ]]; then
  echo "Ошибка: нет index.html." >&2
  exit 1
fi
if [[ ! -f _headers ]]; then
  echo "Ошибка: нет _headers (кэш HTML/MP3 для Pages)." >&2
  exit 1
fi
if [[ ! -f telemetry-heartbeat.mp3 ]]; then
  echo "Ошибка: нет telemetry-heartbeat.mp3 — на сайте не будет звука." >&2
  exit 1
fi

echo "Чеклист перед выкладкой: index.html, _headers, telemetry-heartbeat.mp3, DEPLOY.md — всё из текущей папки." >&2
echo "Содержимое каталога:" >&2
ls -la >&2

# С set -u пустой "${WRANGLER_ENV_ARGS[@]}" в части bash даёт «unbound variable» — ветвим явно.
if [[ ${#WRANGLER_ENV_ARGS[@]} -gt 0 ]]; then
  exec npx --yes wrangler@latest pages deploy . \
    "${WRANGLER_ENV_ARGS[@]}" \
    --project-name ii-integraciya-site \
    --commit-dirty=true
else
  exec npx --yes wrangler@latest pages deploy . \
    --project-name ii-integraciya-site \
    --commit-dirty=true
fi
