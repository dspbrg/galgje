#!/bin/sh
# Bouwt de GitHub Pages-versie (index.html) uit galgje.html, de claude.ai-artifactversie.
# galgje.html heeft geen eigen <html>/<head>: die zet claude.ai er bij publiceren omheen.
# Hier doen we dat zelf, met manifest, icoontjes, de Overhoren-lijsten en de service worker.
set -e
cd "$(dirname "$0")"
VERSIE=$(date +%Y%m%d%H%M%S)
python3 - "$VERSIE" <<'PY'
import sys, re
versie = sys.argv[1]
src = open("galgje.html", encoding="utf-8").read()
head_end = src.index("</style>") + len("</style>")
head, body = src[:head_end], src[head_end:]
title = re.search(r"<title>.*?</title>", head).group(0)
head = head.replace(title, "", 1).strip()
title = "<title>Galgje</title>"  # the artifact keeps its own gallery name
body = body.replace("<script>", '<script src="../overhoren/lists.js"></script>\n<script>', 1)
page = f"""<!DOCTYPE html>
<html lang="nl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
{title}
<link rel="icon" type="image/png" href="icons/icoon-192.png">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="Galgje">
<meta name="theme-color" content="#F4F3F8" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#16142A" media="(prefers-color-scheme: dark)">
{head}
</head>
<body>
{body.strip()}
<script>
if ("serviceWorker" in navigator) navigator.serviceWorker.register("sw.js?v={versie}").catch(() => {{}});
</script>
</body>
</html>
"""
open("index.html", "w", encoding="utf-8").write(page)
sw = open("sw.js", encoding="utf-8").read()
sw = re.sub(r'const VERSIE = "[^"]*";', f'const VERSIE = "{versie}";', sw)
open("sw.js", "w", encoding="utf-8").write(sw)
PY
echo "index.html gebouwd, versie $VERSIE"
