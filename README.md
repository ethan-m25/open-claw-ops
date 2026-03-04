# open-claw-ops

运维知识库。记录三代理系统的架构、脚本、runbooks 和变更历史。

**最后更新**：2026-03-03（v2 架构全面重构）

---

## 系统架构

### 三代理分工

| Agent | 角色 | 模型 | 频道 |
|-------|------|------|------|
| **itachi** | 编排官：任务解析 → 派发 → 验收 → 汇总 | claude-sonnet-4.6（Discord）/ grok-4.1-fast（cron） | #command-center |
| **kisame** | 执行官：宿主机命令、写代码、系统维护、备份 | deepseek-v3.2 | #workshop |
| **zetsu** | 情报官：实时搜索、核查、证据链 | grok-4.1-fast | #intel |

### 关键配置

```
Gateway:      127.0.0.1:18789（loopback only）
sandbox:      kisame=off（宿主机直跑），others=default
execApprovals: Discord DM 按钮审批
Skills:       ~/.openclaw/skills/（12个已安装）
Backup:       ~/openclaw-backups/（保7份）
Heartbeat:    itachi 每日 08:00，grok-4.1-fast
```

### 已安装 Skills（2026-03-03）

| Skill | 主要使用者 | 用途 |
|-------|-----------|------|
| skill-vetter | 全员 | 安装新 skill 前安全审查 |
| self-improving | 全员 | 自我反思纠错 |
| capability-evolver | 全员 | 能力进化引擎 |
| proactive-agent | itachi | WAL Protocol 主动预判 |
| exa | zetsu | 神经语义搜索（需 EXA_API_KEY）|
| safe-exec | kisame | 危险命令自动检测+审批+日志 |
| openclaw-safe-exec | kisame | Prompt injection 防护 |
| mactop | kisame | Apple Silicon 实时指标（~/.local/bin/mactop）|
| browser-automation | kisame | Playwright 网页自动化（exec 审批）|
| openclaw-backup | kisame | ~/.openclaw/ 备份 |
| gog | 全员 | Google Workspace（Gmail/Calendar/Drive）|
| github | kisame | gh CLI（issues/PRs/CI）|

---

## 目录结构

```
open-claw-ops/
├── ops/                    # 运维脚本
│   ├── approval_watcher.py # 文件式审批监听（mirror_inbound_media 用）
│   ├── mirror_inbound_media.sh
│   └── launchd/            # LaunchAgent plist 文件
├── README.md               # 本文件
├── RUNBOOK.md              # 运维操作手册
├── CHANGELOG.md            # 变更日志
└── archive/                # 归档（v1 历史文档，2026-02-28 之前）
```

---

## 写回协议（Write-back Protocol）

**事件驱动**（不做无意义的每日 commit）：
- 修改了 ops/ 脚本或 RUNBOOK
- 完成重要系统配置变更后 kisame 提交
- `[STRUCTURAL]` 标记 → 自动 tag + push

**每周快照（周日）**：kisame 将三代理 workspace 核心文件同步到 `snapshots/YYYY-WW/`

---

## 关键路径

| 用途 | 路径 |
|------|------|
| itachi workspace | `~/.openclaw/workspace-itachi/` |
| kisame workspace | `~/.openclaw/workspace-kisame/` |
| zetsu workspace | `~/.openclaw/workspace-zetsu/` |
| 共享目录 | `~/.openclaw/shared/` |
| OpenClaw 配置 | `~/.openclaw/openclaw.json` |
| Exec 白名单 | `~/.openclaw/exec-approvals.json` |
| 本地备份 | `~/openclaw-backups/` |
