# MEMORY (Long-term)

## Rules
- Only store stable facts and operational decisions.
- Never store tokens/keys/secrets.
- Use bullets, keep concise.

## Current stable decisions
- Discord: allowlist + requireMention; ops managed via open-claw-ops repo.
- Heartbeat: daily 21:10 cron runs ops/backlog-sweep.sh (single-instance lock).
- Model resilience: primary Codex + Gemini fallback (google/gemini-3-pro-preview).
