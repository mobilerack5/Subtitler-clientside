#!/bin/bash
# Ez a szkript elvégzi az FFmpeg LFS beállítását és letöltését

echo "--- 1. LÉPÉS: Git LFS (Large File Storage) telepítése ---"
git lfs install

echo "--- 2. LÉPÉS: .wasm fájlok követése LFS-sel ---"
git lfs track "ffmpeg-dist/*.wasm"

echo "--- 3. LÉPÉS: 'ffmpeg-dist' mappa létrehozása ---"
mkdir -p ffmpeg-dist

echo "--- 4. LÉPÉS: Szükséges FFmpeg fájlok letöltése ---"

echo "Kicsi fájlok letöltése..."
wget https://unpkg.com/@ffmpeg/ffmpeg@0.12.10/dist/ffmpeg.min.js -O ffmpeg-dist/ffmpeg.min.js
wget https://unpkg.com/@ffmpeg/util@0.12.1/dist/ffmpeg-util.min.js -O ffmpeg-dist/ffmpeg-util.min.js
wget https://unpkg.com/@ffmpeg/core-mt@0.12.6/dist/esm/ffmpeg-core.js -O ffmpeg-dist/ffmpeg-core.js
wget https://unpkg.com/@ffmpeg/core-mt@0.12.6/dist/esm/ffmpeg-core.worker.js -O ffmpeg-dist/ffmpeg-core.worker.js

echo "NAGY (.wasm) fájl letöltése (ez eltarthat egy percig)..."
wget https://unpkg.com/@ffmpeg/core-mt@0.12.6/dist/esm/ffmpeg-core.wasm -O ffmpeg-dist/ffmpeg-core.wasm

echo "Letöltések készen."

echo "--- 5. LÉPÉS: Változások hozzáadása a Git-hez ---"
git add .gitattributes ffmpeg-dist/

echo "--- 6. LÉPÉS: Változások mentése (Commit) ---"
git commit -m "Add self-hosted multi-threaded FFmpeg files via Git LFS"

echo "--- 7. LÉPÉS: Feltöltés a GitHub-ra (Push) ---"
echo "Az LFS most fel fogja tölteni a nagy fájlt. Kérlek, várj..."
git push

echo "--- KÉSZ! A fájlok sikeresen feltöltve. ---"
