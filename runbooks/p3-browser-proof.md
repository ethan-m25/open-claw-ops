# P3 Browser Proof (Browser-only)

## Goal
Turn "browser works" into a repeatable proof step that can be reused by agents/cron without manual exploration.

## Preconditions
- Browser profile: openclaw (cdpPort 18800)
- No config changes, no webFetch, no runtime/fs tools.

## Steps
1) Navigate:
   openclaw browser navigate --browser-profile openclaw "https://docs.openclaw.ai/channels/discord#recommended-set-up-a-guild-workspace"

2) Snapshot + locate Guild policy tab:
   openclaw browser snapshot --browser-profile openclaw --efficient --limit 600 > /tmp/p3-eff.txt
   grep -n "Guild policy" /tmp/p3-eff.txt | head -n 5

3) Click the tab (replace REF with the returned ref id, e.g. e85):
   openclaw browser click --browser-profile openclaw REF

4) Snapshot proof:
   openclaw browser snapshot --browser-profile openclaw --efficient --limit 400 | sed -n '1,120p'

## DoD
- Terminal shows: tab "Guild policy" [ref=...] [selected]

## Rollback
- None (read-only). If stuck: openclaw browser stop --browser-profile openclaw && openclaw browser start --browser-profile openclaw
