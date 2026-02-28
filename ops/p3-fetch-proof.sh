#!/usr/bin/env bash
set -euo pipefail

THREAD_ID="1476821643488919592"
URL="https://raw.githubusercontent.com/ethan-m25/open-claw-ops/main/runbooks/discord-allowlist.md"

# Load token if you keep it in ~/.openclaw/.env (safe: file perms 600)
if [ -z "${GITHUB_TOKEN:-}" ] && [ -f "$HOME/.openclaw/.env" ]; then
  # only export the one we need
  export GITHUB_TOKEN="$(grep -E '^GITHUB_TOKEN=' "$HOME/.openclaw/.env" | head -n1 | cut -d= -f2- || true)"
fi

CURL_ARGS=(-fsSL)
if [ -n "${GITHUB_TOKEN:-}" ]; then
  CURL_ARGS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

HTML="$(curl "${CURL_ARGS[@]}" "$URL")"

echo "$HTML" | grep -qiE "allowlist|requireMention|guild" || {
  openclaw message send --channel discord --target "$THREAD_ID" \
    --message "P3 Fetch Proof: FAIL (fetched, but missing keywords) $URL"
  exit 0
}

openclaw message send --channel discord --target "$THREAD_ID" \
  --message "P3 Fetch Proof: PASS ✅ (raw fetch ok; found allowlist/requireMention/guild) $URL"
