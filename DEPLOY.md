# Деплой сайта ИИнтеграция

## Локальный запуск

```bash
cd "/Users/neo/Desktop/САЙТ ИИНТЕГРАЦИЯ"
python3 -m http.server 8090
```

Открыть в браузере: `http://127.0.0.1:8090`

## Публичный деплой в Cloudflare Pages

1. Создай API token в Cloudflare (Wrangler без этого падает на `/memberships`):
   - **User** / **User Details** / **Read** — обязательно
   - **Account** / **Cloudflare Pages** / **Edit**
   - **Account** / **Account Settings** / **Read**

2. Выполни команды (вариант А — токен только в оболочке):

```bash
cd "/Users/neo/Desktop/САЙТ ИИНТЕГРАЦИЯ"
export CLOUDFLARE_API_TOKEN="ВСТАВЬ_СВОЙ_ТОКЕН"
./deploy-cloudflare.sh
```

Вариант Б — токен в файле **вне** папки сайта (не клади `.env` с секретом рядом с `index.html`):

```bash
cd "/Users/neo/Desktop/САЙТ ИИНТЕГРАЦИЯ"
export CLOUDFLARE_ENV_FILE="$HOME/.cloudflare-ii-integraciya.env"
# в этом файле одна строка: CLOUDFLARE_API_TOKEN=...
./deploy-cloudflare.sh
```

Скрипт `deploy-cloudflare.sh` сам сбрасывает `HTTP(S)_PROXY`. Если всё равно видишь `Proxy response 403`, запусти явно:

```bash
cd "/Users/neo/Desktop/САЙТ ИИНТЕГРАЦИЯ"
export CLOUDFLARE_API_TOKEN="…"
env -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY -u http_proxy -u https_proxy ./deploy-cloudflare.sh
```

### Что уходит на Pages (ничего не забыть)

| Файл | Зачем |
|------|--------|
| `index.html` | страница |
| `telemetry-heartbeat.mp3` | фоновый звук (скрипт без него не деплоит) |
| `_headers` | кэш: HTML без долгого кэша, MP3 на неделю |
| `DEPLOY.md` | документация (попадёт в артефакт, вреду нет) |

Скрипт **не** проверяет наличие `deploy-cloudflare.sh` в выкладке — он сам себя не «отдаёт» как статику; в каталоге для деплоя только перечисленное выше + скрытые служебные файлы по поведению Wrangler.

3. После успешного деплоя Wrangler вернёт URL вида:
   - `https://<hash>.ii-integraciya-site.pages.dev`

## Если проект уже существует

Можно использовать то же имя `--project-name`, и Cloudflare создаст новый preview/production deploy без потери настроек проекта.

## Без Wrangler (архив уже собран)

Из этой папки можно собрать zip вручную:

```bash
./package-for-pages.sh
```

Появится **`ii-integraciya-pages.zip`** (`index.html`, `telemetry-heartbeat.mp3`, `_headers`). В [Cloudflare Dashboard](https://dash.cloudflare.com) → **Workers & Pages** → проект **ii-integraciya-site** → **Create deployment** / загрузка production-ассетов → укажи архив или распакуй и загрузи три файла в корень деплоя.
