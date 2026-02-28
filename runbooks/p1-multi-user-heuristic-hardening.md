# P1 multi_user_heuristic hardening (non-Docker) — PLAN

## Goal
Reduce multi-user risk without Docker: deny risky tools for non-allowlisted users while keeping normal allowlisted ops.

## Non-goals (for now)
- No changes to network exposure (keep loopback-only)
- No new web/runtime/fs permissions
- No Docker dependency

## Proposed approach (draft)
- Use tools.profile / tools.deny as the primary guardrail.
- Keep Discord allowlist + requireMention unchanged.
- Validate by ensuring:
  1) openclaw status no longer flags security.trust_model.multi_user_heuristic (or meaningfully reduced)
  2) Non-allowlist cannot invoke fs/runtime
  3) Allowlist can still run intended ops (message-only)

## DoD
- Document exact config keys + commands + rollback
- Canary in test thread first
- Record change in skills-audit.md and ops-changelog.md

## Rollback
- Restore ~/.openclaw/openclaw.json.bak.<timestamp>
- openclaw gateway restart
