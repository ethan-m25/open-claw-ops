# P1 multi_user_heuristic hardening (non-Docker) — PLAN

## Goal
Reduce multi-user risk without Docker by tightening tool exposure while keeping normal allowlisted ops working.

## Current baseline (as of v0.6)
- gateway.bind = loopback only
- Discord: allowlist + requireMention
- Heartbeat: cron runs ops/backlog-sweep.sh daily

## Plan (draft)
1) Define a strict global tools baseline (messaging-only).
2) Allowlist-specific exceptions (if needed) with explicit commands only.
3) Verify multi_user_heuristic warning is reduced/removed.
4) Record changes + rollback in ops repo.

## DoD
- Exact config keys + commands + rollback steps documented
- Canary in test thread first, then promote to STABLE

## Rollback
- Restore ~/.openclaw/openclaw.json.bak.<timestamp>
- openclaw gateway restart
