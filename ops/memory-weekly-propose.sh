#!/usr/bin/env bash
set -euo pipefail
THREAD_ID="1476821643488919592"

REPO_DIR="${HOME}/open-claw-ops"
cd "$REPO_DIR"

# Collect last 7 daily logs if present
FILES="$(ls -1t memory/*.md 2>/dev/null | head -n 7 || true)"
OUTFILE="proposals/memory-proposal-$(date +%Y%m%d-%H%M%S).md"

{
  echo "# MEMORY.md proposal (append-only)"
  echo
  echo "Generated: $(date)"
  echo
  echo "## Source daily logs"
  if [[ -z "${FILES}" ]]; then
    echo "- (none found)"
  else
    echo "${FILES}" | sed 's/^/- /'
  fi
  echo
  echo "## Proposed additions to MEMORY.md"
  echo
  echo "> Append the following lines to MEMORY.md after review:"
  echo
  if [[ -z "${FILES}" ]]; then
    echo "- (no input logs yet)"
  else
    # Extract only the “Stable decisions” and “Config changes” sections, lightly
    for f in ${FILES}; do
      echo "### From $(basename "$f")"
      sed -n '/^## Stable decisions today/,/^## /p' "$f" | sed '$d' || true
      sed -n '/^## Config changes/,/^## /p' "$f" | sed '$d' || true
      echo
    done
  fi
} > "$OUTFILE"

echo "$OUTFILE"
THREAD_ID="1476821643488919592"
openclaw message send --channel discord --target "${THREAD_ID}" --message "MEMORY PROPOSAL READY: ${OUTFILE} (review + manually apply to MEMORY.md if desired)" || true
