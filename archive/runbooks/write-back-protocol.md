# Write-back Protocol（可控写回闭环）

目标：让 Agent 产出变更，但不直接写入 main；所有落盘进入 main 都经由人类审核。

## 默认方案 A：Patch / PR（推荐）
### 1) Agent 产出
- Agent 只能产出两类东西之一：
  1. `proposals/*.patch`（或 `.diff`）
  2. GitHub PR（仅在不触碰 RED 的前提下）

### 2) 人类审核与落盘（Terminal）
- 本地应用 patch：
  - `git apply proposals/xxx.patch`
  - 验证：`git diff` 检查内容是否符合预期
- 提交并推送：
  - `git add -A && git commit -m "<message>" && git push`

### 3) 规则（硬约束）
- Agent 不得要求你提供写权限 token。
- Agent 的“下一步唯一动作”只能是：
  - “生成 patch/PR 草案” 或 “让你执行一次 apply/commit/push”。

## 方案 B：受限分支（可选，RED）
- 需要写权限 token + 分支保护策略，属于 RED，必须走 FUSE。
