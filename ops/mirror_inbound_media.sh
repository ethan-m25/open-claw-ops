#!/usr/bin/env bash
set -euo pipefail

SRC="/Users/clawii/.openclaw/media/inbound"
DST="/Users/clawii/.openclaw/shared/artifacts/media"

mkdir -p "$DST"

# Copy only common image types; keep originals intact
shopt -s nullglob
for f in "$SRC"/*.{png,jpg,jpeg,webp,gif}; do
  base="$(basename "$f")"
  # copy if missing or source is newer
  if [[ ! -e "$DST/$base" || "$f" -nt "$DST/$base" ]]; then
    cp -p "$f" "$DST/$base"
  fi
done
