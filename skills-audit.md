# P0 Skills Audit Log

## Format (one row per change)
Date | Skill | Mode (Browser-only/Canary/Stable) | Scope (channels) | Provider | Permissions | Cost cap | Logs/Artifacts | Rollback
---|---|---|---|---|---|---|---|---

## Entries
2026-02-27 | P0-S1 Search | CANARY-PASS (Browser-only) | #workshop | Browser-only (openclaw browser profile) | N/A | N/A | README: P0-S1 Canary section | Revert to manual browsing only

2026-02-28 | P0-S2 GitHub Read-only | CANARY-PASS (text-in-thread fallback) | #workshop | open-claw-ops (SSH) | repo read | N/A | README: P0-S2 KISAME_OK section | Paste text (no URL fetch) fallback

2026-02-28 | Heartbeat Backlog Sweep | STABLE (cron runs script) | #command-center thread(1476821643488919592) | local (cron + openclaw agent) | message.read + message.send only | N/A | ops/backlog-sweep.sh + ops/crontab.txt | crontab -l | grep -v backlog-sweep.sh | crontab -
