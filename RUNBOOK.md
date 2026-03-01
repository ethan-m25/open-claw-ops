# Runbook: Discord Elevation Stop-Loss

## Overview
Due to a known bug in OpenClaw v2026.2.25 where Discord channel identification and permission resolution are unreliable, we are temporarily deactivating the “Discord-triggered elevated” workflow for automated multi-agent tasks.

This runbook documents:
- The known issues and evidence.
- The stop‑loss decision.
- The fallback workflow (Host‑based approval).
- Rollback criteria (when the bug is fixed).

---

## Known Issues & Evidence

### 1. Local reproduction
- `sandbox explain` consistently reports `Elevated channel=(unknown)` for the Discord channel even when `sandbox tools allow=discord` is set.
- `allowFrom` path evaluation fails, causing sub‑agents to see “channel unknown,” blocking reliable channel‑based elevation.
- Workaround attempts (runtime=direct + allowFrom) do not resolve the channel‑mapping failure.

### 2. Community reports (GitHub issues)
- Issue #xxx (Feb 2026): “elevated unreliable in subagent/sandbox scenarios – drops connection, requires new message to recover.”
- Issue #yyy (Feb 2026): “allowFrom/authorization resolution bug in Discord snowflake ID handling.”
- Issue #zzz (Feb 2026): “Discord channel‑ID numeric overflow causing channel‑lookup failures.”
- These issues collectively block the “Discord‑triggered elevated” automation path for v2026.2.25.

### 3. Operational impact
- Multi‑agent automation that relies on Discord‑based elevation is **not stable**.
- This interrupts the planned “three‑agent coordination loop” where:
  - Itachi dispatches via Discord channel.
  - Kisame/Zetsu receive tasks and request elevated.
  - Discord elevation times out or returns unknown.
  - The loop deadlocks.

---

## Decision: Stop‑Loss

**Effective date:** 2026‑03‑01  
**Target version:** OpenClaw v2026.2.25  
**Status:** 🛑 **Stop‑Loss / Known Issue**

**Decision:**  
We cease investment in “Discord‑triggered elevated” as the primary automation path for v2026.2.25.  
We switch to a **Host‑based approval (Terminal/Control UI) + Kisame‑as‑Host‑executor** model.

**Rollback criteria:**  
When a future OpenClaw version (≥ v2026.3.x) confirms the fixes for:
1. Discord snowflake ID precision loss.
2. `allowFrom` path‑evaluation bug.
3. Sub‑agent elevated channel‑lookup stability.

---

## Fallback Workflow (Host‑based)

### 1. Approval channels
- **Terminal:** Human (`Ethan`) approves via `openclaw approve <task‑id>`.
- **Control UI:** Human approves via OpenClaw’s web UI (if enabled).
- **File‑based:** Approval token written to `shared/approvals/`; Kisame polls and executes.

### 2. Kisame as Host‑side executor
When a task requires elevated host‑side commands (system config, package install, gateway restart):
```yaml
agents:
  kisame:
    runtime: direct   # runs on host, bypasses sandbox for host‑side actions
    allowedPaths:
      - /etc/openclaw
      - /usr/local/bin
      - /Users/clawii/.openclaw/config.yaml
```

### 3. Evidence chain
All evidence (screenshots, logs, status outputs) must be written to `shared/evidence/` before the final “Done” report.

**Example flow:**
```
shared/
├── tasks/
│   ├── todo/task‑123.json
│   ├── doing/kisame‑task‑123.json
│   └── done/task‑123‑report.md
├── evidence/
│   └── task‑123‑screenshot.png
└── approvals/
    └── task‑123‑approved.txt
```

---

## Rollback Steps

When the Discord elevation bug is fixed in a future release:
1. **Verify fix:** Confirm channel‑lookup and allowFrom work reliably in `sandbox explain`.
2. **Update runbook:** Mark this runbook as “archived” and point to new Discord‑based workflow.
3. **Re‑enable:** Restore `runtime=sandbox` for Kisame/Zetsu; re‑enable Discord‑triggered elevation in config.
4. **Test:** Run a full three‑agent drill to confirm end‑to‑end flow.

---

## References
- [OpenClaw Issue #xxx – Discord elevation unreliable](https://github.com/openclaw/openclaw/issues/xxx)
- [OpenClaw Issue #yyy – allowFrom path evaluation bug](https://github.com/openclaw/openclaw/issues/yyy)
- [OpenClaw Issue #zzz – Snowflake ID precision loss](https://github.com/openclaw/openclaw/issues/zzz)
- Local `memory/2026‑03‑01.md` – “Decision Log: Discord Elevation Stop‑Loss”

---

**Last updated:** 2026‑03‑01  
**Maintainer:** @itachi  
**Review cycle:** Monthly (check for upstream fixes)