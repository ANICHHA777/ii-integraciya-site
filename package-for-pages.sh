#!/usr/bin/env bash
# Собирает архив только из файлов, которые должны оказаться на Pages (без скриптов и секретов).
set -euo pipefail
cd "$(dirname "$0")"

for f in index.html telemetry-heartbeat.mp3 _headers; do
  if [[ ! -f "$f" ]]; then
    echo "Нет файла: $f" >&2
    exit 1
  fi
done

OUT="ii-integraciya-pages.zip"
rm -f "$OUT"
zip -X "$OUT" index.html telemetry-heartbeat.mp3 _headers
echo "Готово: $(pwd)/$OUT" >&2
unzip -l "$OUT" >&2
