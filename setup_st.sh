#!/bin/bash

echo "--- 1. LÉPÉS: Régi LFS és Multi-Threaded fájlok törlése ---"
# Kikapcsoljuk az LFS követést
git lfs untrack "ffmpeg-dist/*.wasm"

# Törlünk minden régi fájlt a mappából
rm -f ffmpeg-dist/ffmpeg-core.js
rm -f ffmpeg-dist/ffmpeg-core.wasm
rm -f ffmpeg-dist/ffmpeg-core.worker.js
rm -f ffmpeg-dist/ffmpeg.min.js
rm -f ffmpeg-dist/ffmpeg-util.min.js
rm -f .gitattributes # Töröljük a régi LFS beállítást is

echo "Régi fájlok törölve."

echo "--- 2. LÉPÉS: Új, 25MB alatti (Single-Thread) fájlok letöltése ---"

# A segédfájlok (ezek ugyanazok)
wget https://unpkg.com/@ffmpeg/ffmpeg@0.12.10/dist/ffmpeg.min.js -O ffmpeg-dist/ffmpeg.min.js
wget https://unpkg.com/@ffmpeg/util@0.12.1/dist/ffmpeg-util.min.js -O ffmpeg-dist/ffmpeg-util.min.js

# Az EGY-SZÁLÚ (ST) mag (a 24.9MB-os .wasm)
wget https://unpkg.com/@ffmpeg/core@0.12.6/dist/esm/ffmpeg-core.js -O ffmpeg-dist/ffmpeg-core.js
wget https://unpkg.com/@ffmpeg/core@0.12.6/dist/esm/ffmpeg-core.wasm -O ffmpeg-dist/ffmpeg-core.wasm

echo "Letöltés kész. Fájlméretek ellenőrzése:"
ls -lh ffmpeg-dist/

echo "--- 3. LÉPÉS: Változások feltöltése a GitHub-ra ---"
git add ffmpeg-dist/ .gitattributes
git commit -m "Switch to Single-Thread (ST) self-hosted FFmpeg"
git push

echo "--- KÉSZ! A repó frissítve az egy-szálú (ST) verzióra. ---"
