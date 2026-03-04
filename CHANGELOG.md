# CHANGELOG

## 2026-03-03 — v2 全面重构（当前状态）

### 架构变更
- 从单一 agent → 三代理架构（itachi / kisame / zetsu）
- kisame sandbox.mode = off（宿主机直跑）
- execApprovals 从 Flask/iPhone Shortcuts → Discord 按钮 DM（原生）
- Discord 图片从 mirror 脚本 → 直接读 ~/.openclaw/media/inbound/

### 模型更新
- itachi: grok-4.1-fast → claude-sonnet-4.6（Discord 会话）
- zetsu: gemini-3-flash-preview → grok-4.1-fast
- 心跳 cron 模型: grok-4.1-fast（省费）
- 心跳时间: */30 → 每日 08:00

### Skills 新增（12个）
skill-vetter, self-improving, capability-evolver, proactive-agent,
exa, safe-exec, openclaw-safe-exec, mactop, browser-automation,
openclaw-backup, gog, github

### 文档更新
- 三代理 SOUL.md 全部重写（从通用模板 → 角色专属）
- 三代理 TOOLS.md 全部重写（从空模板 → 完整工具速查）
- ORCH.md v2（sessions_send 标准工作流，DoD 验收强化）
- OPS_GUARDRAILS.md v2026.3.2（移除 Flask，加入 execApprovals）

### 工具配置
- itachi tools: 新增 fs + web_fetch（文件验收 + URL 读取）
- zetsu tools: 新增 sessions_send/list/history + web_search + web_fetch
- EXA_API_KEY: 已配置 ~/.zshenv + ~/.zshrc
- mactop: v0.2.7 直接安装 ~/.local/bin/（无需 brew）

---

## 2026-02-28 — v1 初始化（已归档）

详见 archive/ops-changelog-v1.md
