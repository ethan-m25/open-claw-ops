# RUNBOOK — open-claw-ops

运维操作手册。记录 v2 三代理系统的日常操作、写回协议和快照机制。

**最后更新**：2026-03-03

---

## 写回协议（Write-back Protocol）

### 原则
**事件驱动，不做噪声提交。** 以下情况触发写回：

| 触发条件 | 操作 |
|---------|------|
| `ops/` 脚本变更 | kisame `git add ops/ && git commit` |
| RUNBOOK.md 更新 | kisame `git add RUNBOOK.md && git commit` |
| 重要系统配置变更（openclaw.json、工具、cron 等） | kisame 记录到 CHANGELOG.md 后提交 |
| `[STRUCTURAL]` 标记提交 | 自动触发 `structural-YYYYMMDD-HHMMSS` tag + push（pre-commit hook）|

### kisame 标准写回流程

```bash
cd ~/open-claw-ops

# 常规变更
git add <specific-files>
git commit -m "ops: <描述变更内容>"
git push origin main

# 重要结构性变更（加 [STRUCTURAL] 标记）
git add -A
git commit -m "ops: [STRUCTURAL] <描述>"
# hook 自动创建 tag 并 push
```

### 禁止事项
- 不每日空提交"daily update"
- 不提交 `~/.openclaw/` 中的敏感配置（openclaw.json 含密钥）
- 不提交 `media/` 或 `backups/`

---

## 每周快照（Weekly Snapshot）

**执行人**：kisame（cron 触发）
**时间**：每周日 09:00
**脚本**：`~/open-claw-ops/ops/weekly-snapshot.sh`

### 快照内容

每个 agent workspace 的核心 MD 文件快照到：

```
snapshots/YYYY-WW/
├── itachi/   (SOUL.md, TOOLS.md, AGENTS.md, ORCH.md)
├── kisame/   (SOUL.md, TOOLS.md, AGENTS.md)
└── zetsu/    (SOUL.md, TOOLS.md, AGENTS.md)
```

### 手动触发

```bash
bash ~/open-claw-ops/ops/weekly-snapshot.sh
```

---

## 系统重启流程

### 网关重启

```bash
openclaw gateway restart
openclaw gateway status
openclaw agents list
```

### 环境变量（重启后需验证生效）

`~/.zshenv` 应包含：
```bash
export EXA_API_KEY="d0d9614a-58d8-4166-9b27-4ae6b6e2761e"
export PATH="$HOME/.local/bin:$PATH"
```

---

## 备份与恢复

### 立即备份

```bash
bash ~/.openclaw/skills/openclaw-backup/scripts/backup.sh
# 输出：~/openclaw-backups/openclaw-YYYY-MM-DD_HHMM.tar.gz（保留最近7份）
```

### 回滚到最新 STRUCTURAL tag

```bash
bash ~/open-claw-ops/ops/rollback-to-latest-structural-tag.sh
```

---

## exec 审批操作

### 白名单查看

```bash
cat ~/.openclaw/exec-approvals.json
```

### 手动批准

Discord DM 审批按钮点击 "Approve"，或：
```bash
safe-exec-approve <request-id>
```

---

## Host Approval Channel（文件式审批）

用于 mirror_inbound_media 等白名单动作。

### 目录结构
- `~/.openclaw/shared/requests/`  — agent 提交请求（JSON）
- `~/.openclaw/shared/approvals/` — owner 手写审批（chmod 700）
- `~/.openclaw/shared/ops/`       — 执行日志和收据

### 已审批动作：mirror_inbound_media

将 Discord 附件从 `~/.openclaw/media/inbound/` 镜像到 `~/.openclaw/shared/artifacts/media/`。

审批流程：
```bash
# approval_watcher.py 自动监听并执行白名单动作
# launchd plist: ~/open-claw-ops/ops/launchd/com.openclaw.approval-watcher.plist
```

---

## Cron 任务（截至 2026-03-03）

| ID | 说明 | 时间 |
|----|------|------|
| `ca90c90d` | itachi 心跳（grok-4.1-fast） | 每日 08:00 |
| — | 每周快照（kisame exec） | 每周日 09:00 |

```bash
openclaw cron list
```

---

## 故障排查

```bash
# agent 在线状态
openclaw agents list

# safe-exec 日志
tail -50 ~/.openclaw/safe-exec-audit.log

# approval_watcher 日志
tail -50 ~/.openclaw/shared/ops/approval_watcher.log

# 网关端口冲突
lsof -i :18789
```

---

## 关键路径速查

| 用途 | 路径 |
|------|------|
| OpenClaw 配置 | `~/.openclaw/openclaw.json` |
| Exec 白名单 | `~/.openclaw/exec-approvals.json` |
| 本地备份 | `~/openclaw-backups/` |
| safe-exec 日志 | `~/.openclaw/safe-exec-audit.log` |
| 共享目录 | `~/.openclaw/shared/` |
| Discord 媒体 | `~/.openclaw/media/inbound/` |
| mactop binary | `~/.local/bin/mactop` |
