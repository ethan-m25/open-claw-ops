#!/usr/bin/env bash
set -euo pipefail

THREAD_ID="1476821643488919592"
URL="https://raw.githubusercontent.com/ethan-m25/open-claw-ops/main/runbooks/discord-allowlist.md"

HTML="$(curl -fsSL "$URL")"

echo "$HTML" | grep -qiE "allowlist|requireMention|guild" || {
  openclaw message send --channel discord --target "$THREAD_ID" \
    --message "P3 Fetch Proof: FAIL (raw fetch ok, but missing keywords) $URL"
  exit 0
}

openclaw message send --channel discord --target "$THREAD_ID" \
  --message "P3 Fetch Proof: PASS ✅ (curl raw ok; found allowlist/requireMention/guild) $URL"
