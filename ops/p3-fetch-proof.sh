#!/usr/bin/env bash
set -euo pipefail

THREAD_ID="1476821643488919592"
URL="https://docs.openclaw.ai/channels/discord"

HTML="$((curl -sL "$URL"))"

# Minimal proof signals (avoid brittle DOM selectors)
echo "$HTML" | grep -qi "channels.discord.dmPolicy" || {
  openclaw message send --channel discord --target "$THREAD_ID" --message "P3 Fetch Proof: FAIL (missing channels.discord.dmPolicy) $URL"
  exit 0
}
echo "$HTML" | grep -qi "Guild policy" || {
  openclaw message send --channel discord --target "$THREAD_ID" --message "P3 Fetch Proof: FAIL (missing Guild policy tab) $URL"
  exit 0
}

openclaw message send --channel discord --target "$THREAD_ID" --message "P3 Fetch Proof: PASS ✅ (curl ok; found dmPolicy + Guild policy) $URL"
