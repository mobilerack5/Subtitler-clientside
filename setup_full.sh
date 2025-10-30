#!/bin/bash
# Ez a VÉGLEGES szkript. Letölti a HELYES (UMD) formátumú
# FFmpeg fájlokat ÉS az AI (Transformers.js) fájlokat.

echo "--- 1. LÉPÉS: Régi fájlok és LFS törlése ---"
git lfs untrack "ffmpeg-dist/*.wasm" > /dev/null 2>&1
rm -f ffmpeg-dist/*
rm -f .gitattributes
rm -rf transformers-dist # Töröljük a régi AI mappát is, ha van
echo "Régi fájlok törölve."

echo "--- 2. LÉPÉS: HELYES (UMD) FFmpeg fájlok letöltése ---"
mkdir -p ffmpeg-dist
# A 25MB alatti, EGY-SZÁLÚ (Single-Thread) UMD verzió:
wget https://unpkg.com/@ffmpeg/ffmpeg@0.12.10/dist/ffmpeg.min.js -O ffmpeg-dist/ffmpeg.min.js
wget https://unpkg.com/@ffmpeg/core@0.12.6/dist/umd/ffmpeg-core.js -O ffmpeg-dist/ffmpeg-core.js
wget https://unpkg.com/@ffmpeg/core@0.12.6/dist/umd/ffmpeg-core.wasm -O ffmpeg-dist/ffmpeg-core.wasm
# Figyelem: az 'ffmpeg-util.min.js'-re az UMD betöltőnek nincs szüksége!

echo "FFmpeg (ST UMD) fájlok letöltve."

echo "--- 3. LÉPÉS: AI (Transformers.js) fájlok letöltése ---"
mkdir -p transformers-dist
wget https://cdn.jsdelivr.net/npm/@xenova/transformers@2.17.1/dist/transformers.min.js -O transformers-dist/transformers.min.js

echo "AI (Transformers.js) fájlok letöltve."

echo "--- 4. LÉPÉS: Változások feltöltése a GitHub-ra ---"
git add ffmpeg-dist/ transformers-dist/ .gitattributes
git commit -m "Add FULL self-hosted UMD FFmpeg and Transformers.js"
git push

echo "--- KÉSZ! A repó frissítve a v2.18-as (teljesen self-hosted) verzióra. ---"
