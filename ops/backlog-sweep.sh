#!/usr/bin/env bash
set -euo pipefail

LOCKFILE="/tmp/openclaw-backlog-sweep.lock"
if ! shlock -f "$LOCKFILE" -p $$; then
  exit 0
fi
trap 'rm -f "$LOCKFILE"' EXIT

THREAD_ID="1476821643488919592"

# Local status snapshot (no git)
LOGDIR="${HOME}/.openclaw/ops-logs"
mkdir -p "$LOGDIR" || true
openclaw status --all 2>&1 | tail -n 120 > "$LOGDIR/status-$(date +%Y%m%d-%H%M%S).txt" || true

# Persist latest next action locally
NEXT_ACTION_FILE="$LOGDIR/next-action-latest.txt"

REPO_DIR="${HOME}/open-claw-ops"
BACKLOG_FILE="${REPO_DIR}/BACKLOG.md"

# Script reads truth source and injects as plain text (agent needs no fs tool)
BACKLOG_TEXT="$(sed -n '1,200p' "$BACKLOG_FILE" | sed 's/`/\\`/g')"

OUT="$(openclaw agent --to "discord:${THREAD_ID}" --message "AUTO Backlog Sweep（不执行变更，SOURCE=BACKLOG_MD_TEXT）：
以下是本次 Sweep 的真相源 BACKLOG.md（截取前200行）：
<<<
${BACKLOG_TEXT}
>>>

请只挑 1 条最阻塞/最有价值项，输出 1 条【下一步唯一动作】：目的/操作/验证/回滚。不要执行任何变更。" --deliver 2>&1 || true)"

# Always store a local copy of the latest output (sanitized & truncated)
printf "%s\n" "$OUT" | sed '/^DELIVER_DEBUG=1$/d' | sed -n '1,200p' > "$NEXT_ACTION_FILE" || true

if echo "$OUT" | grep -qiE "rate limit|cooldown|All models failed"; then
  openclaw message send --channel discord --target "${THREAD_ID}" --message "Heartbeat AUTO Sweep: skipped (provider cooldown/rate_limit)."
else
  openclaw message send --channel discord --target "${THREAD_ID}" --message "MEMORY CHECK: 如果今天产生了稳定决策（策略/护栏/固定配置变更），请在 open-claw-ops/MEMORY.md 追加一条。"
  openclaw message send --channel discord --target "${THREAD_ID}" --message "$(printf "%s\n" "$OUT" | sed '/^DELIVER_DEBUG=1$/d' | sed -n '1,120p')"
fi
