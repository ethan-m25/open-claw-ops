#!/usr/bin/env bash
set -euo pipefail

LOCKFILE="/tmp/openclaw-backlog-sweep.lock"
exec 9>""
if ! flock -n 9; then
  exit 0
fi


THREAD_ID="1476821643488919592"

# Run one agent turn (may fail during provider cooldown / rate_limit)
OUT="$(openclaw agent --to "discord:${THREAD_ID}" --message "AUTO Backlog Sweep（不执行变更）：请读取该 thread 最近消息（openclaw message read --channel discord --target ${THREAD_ID} --limit 30），定位包含 'Checkpoint v0.5' 或 'Backlog' 的那条，然后只输出 1 条【下一步唯一动作】：目的/操作/验证/回滚。" --deliver 2>&1 || true)"

# If agent failed, post a short notice; otherwise post output (truncated)
if echo "$OUT" | grep -qiE "rate limit|cooldown|All models failed"; then
  openclaw message send --channel discord --target "${THREAD_ID}" --message "Heartbeat AUTO Sweep: skipped (provider cooldown/rate_limit)."
else
  openclaw message send --channel discord --target "" --message "MEMORY CHECK: 如果今天产生了稳定决策（策略/护栏/固定配置变更），请在 open-claw-ops/MEMORY.md 追加一条。"

openclaw message send --channel discord --target "${THREAD_ID}" --message "$(echo "$OUT" | sed -n '1,120p')"
fi
