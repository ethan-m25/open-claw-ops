# Discord Allowlist Runbook (P0)

## Purpose
Restrict OpenClaw Discord trigger surface to an allowlist (guild + channels), require mentions, and keep gateway loopback-only.

## Preconditions
- Backup exists: ~/.openclaw/openclaw.json.bak.<timestamp>
- groupPolicy = allowlist

## Steps (purpose / action / verify / rollback)
1) Set groupPolicy to allowlist
- Action:
  openclaw config set channels.discord.groupPolicy allowlist
  openclaw gateway restart
- Verify:
  openclaw status (security audit has 0 critical)
- Rollback:
  restore openclaw.json backup + gateway restart

2) Allowlist a guild + channels (minimum set)
- Action (example):
  openclaw config set channels.discord.guilds '{ "<GUILD_ID>": { "requireMention": true, "channels": { "<CHANNEL_ID>": { "allow": true } } } }' --json
  openclaw gateway restart
- Verify:
  Bot responds only in allowed channels (with mention)
- Rollback:
  remove guild entry or restore backup + restart

## Notes
- Evidence links: see README P0-S1 Canary section.
