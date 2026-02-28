# P2 Web Fetch Allowlist (Draft)

## Goal
Enable evidence-based browsing with strict domain allowlist and citation output.

## Allowed domains (initial canary)
- docs.openclaw.ai
- raw.githubusercontent.com
- github.com

## Output format requirement
- Conclusion (1-2 lines)
- Evidence links (2-5)
- Risks (1-3)
- Next unique action (purpose/ops/verify/rollback)

## Explicitly disallowed
- Any non-allowlisted domain
- Any login-required / paywalled content
- Any action that changes external state (posting, purchasing, account changes)

## Rollback
Disable web fetch / remove allowlist and revert to Browser-only manual workflow.
