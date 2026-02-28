#!/usr/bin/env bash
set -euo pipefail

THREAD_ID="1476821643488919592"
OWNER="ethan-m25"
REPO="open-claw-ops"
PATH_IN_REPO="contracts/masterplan-v0.7-part1.md"
REF="main"

: "${GITHUB_TOKEN:?missing GITHUB_TOKEN in environment (expected in ~/.openclaw/.env for gateway)}"

API_URL="https://api.github.com/repos/${OWNER}/${REPO}/contents/${PATH_IN_REPO}?ref=${REF}"

HTML="$(curl -fsSL \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github.raw" \
  "$API_URL")"

echo "$HTML" | grep -qiE "RED|FUSE|下一步唯一动作|Operator Contract" || {
  openclaw message send --channel discord --target "$THREAD_ID" \
    --message "P3 Fetch Proof: FAIL (GitHub API fetch ok, but missing expected keywords) ${OWNER}/${REPO}@${REF}:${PATH_IN_REPO}"
  exit 0
}

openclaw message send --channel discord --target "$THREAD_ID" \
  --message "P3 Fetch Proof: PASS ✅ (GitHub API raw ok; found policy keywords) ${OWNER}/${REPO}@${REF}:${PATH_IN_REPO}"
