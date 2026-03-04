# Ops Changelog

Date | Change | Artifact | Notes
---|---|---|---
2026-02-28 | Snapshot current OpenClaw config (redacted) | snapshots/openclaw.json.20260228-004004.redacted | Baseline for rollback/diff

## 2026-02-28
- Enabled Gemini fallback: google/gemini-3-pro-preview added to fallbacks + allowlist; Codex cooldown no longer blocks agent runs.
- Heartbeat automation validated: backlog sweep can post results back to Discord thread.
- Stabilized P0-S2: Added runbooks/p0-s2-text-in-thread-fallback.md as STABLE runbook.

## 2026-02-28 (Models resilience)
- Added fallback: google/gemini-3-pro-preview (and allowlisted it) so agent runs continue during Codex cooldown.
