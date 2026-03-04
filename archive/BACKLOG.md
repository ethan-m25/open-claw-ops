# BACKLOG

## P0 (must)
- (empty)

## P1 (should)
- multi_user_heuristic: keep as backlog (non-blocking); see runbooks/p1-multi-user-heuristic-hardening.md
- Long-term memory maintenance strategy for MEMORY.md (via heartbeat)

## P2 (nice)
- Improve formatting template for sweep output
- [ ] **P1+: 设计“可控写回闭环”**
  - **目标**：让 Agent 能安全地向 `open-claw-ops` 提交代码/文档变更。
  - **方案 A (Patch/PR - 默认推荐)**：
    - 机制：Agent 产出 `diff/patch` 文件 -> 存入 `proposals/` -> 人工 `git apply`。
    - 优点：0 权限泄露，完全审计。
  - **方案 B (受限分支)**：
    - 机制：赋予 Token 写权限 -> 仅允许 push 到 `agent/*` -> 提 PR 进 main。
    - 缺点：涉及 Token 升级 (RED)，需配置 Branch Protection。
  - **Next**：选择方案并编写 `runbooks/write-back-protocol.md`。
