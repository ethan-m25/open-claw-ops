#!/usr/bin/env bash
set -euo pipefail

THREAD_ID="1476821643488919592"
LOCKFILE="/tmp/openclaw-p3-browser-proof.lock"

# macOS single-instance lock
if ! shlock -f "$LOCKFILE" -p $$; then
  exit 0
fi
trap 'rm -f "$LOCKFILE"' EXIT

# Run proof (read-only)
openclaw browser navigate --browser-profile openclaw "https://docs.openclaw.ai/channels/discord#recommended-set-up-a-guild-workspace" >/dev/null
openclaw browser snapshot --browser-profile openclaw --efficient --limit 800 > /tmp/p3-eff.txt

REF="20 20 12 61 100 701 702grep -nEi "guild policy" /tmp/p3-eff.txt | head -n 1 | sed -n 's/.*\[ref=\([a-z0-9]\+\)\].*/\1/p' )"
if [[ -z "${REF:-}" ]]; then
  openclaw message send --channel discord --target "${THREAD_ID}" --message "P3 Browser Proof: FAIL (could not find Guild policy tab ref)."
  exit 0
fi

openclaw browser click --browser-profile openclaw "$REF" >/dev/null

# Re-snapshot and extract the proof line
openclaw browser snapshot --browser-profile openclaw --efficient --limit 900 > /tmp/p3-eff2.txt
PROOF="$(grep -n 'tab "Guild policy"' /tmp/p3-eff2.txt | head -n 1 || true)"

if echo "$PROOF" | grep -q "\[selected\]"; then
  openclaw message send --channel discord --target "${THREAD_ID}" --message "P3 Browser Proof: PASS ✅  ${PROOF}"
else
  openclaw message send --channel discord --target "${THREAD_ID}" --message "P3 Browser Proof: WARN (tab found but not selected). ${PROOF}"
fi
