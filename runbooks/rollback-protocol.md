# Rollback Protocol（Discord 手机端审计 → 自动回滚）

## 目标
让 Operator 只用手机在 Discord 发一条明确指令，就能触发 Agent 执行回滚脚本，并把结果回报到同一线程；同时避免误触发与滥用。

## 安全原则（硬约束）
- **默认不执行**：任何“rollback”相关消息都只视为“请求”，除非满足“武装口令”。
- **必须显式指定目标**：要么指定 structural tag，要么默认回滚到最新 structural tag（脚本支持）。
- **必须在指定线程**：只响应固定 THREAD_ID（防止别的频道误触发）。
- **必须二次确认**：采用两段式口令（ARM → EXEC），降低误触发概率。
- **执行动作会 force-with-lease 推 main**：属于高风险操作，必须有审计回报。

## Discord 指令格式（两段式）
1) 预检（只 dry-run，不改任何东西）
- `rollback preview`
- `rollback preview tag=structural-YYYYMMDD-HHMMSS`

2) 武装（仅标记“准备执行”，仍不执行）
- `rollback arm`
- `rollback arm tag=structural-YYYYMMDD-HHMMSS`

3) 执行（必须带口令，且 arm 后 5 分钟内有效）
- `rollback exec FUSE ARMED`
- `rollback exec FUSE ARMED tag=structural-YYYYMMDD-HHMMSS`

## 预期行为（Agent）
- preview：运行 `bash ops/rollback-to-latest-structural-tag.sh`（不带 RUN=1），把输出摘要回帖。
- arm：回帖确认“已武装”，并回帖提示有效期/目标 tag。
- exec：运行 `RUN=1 bash ops/rollback-to-latest-structural-tag.sh origin main`（或指定 tag 的变体实现），完成后回帖：
  - 回滚到的 tag
  - 回滚前/后 commit
  - force push 结果（成功/失败）
  - 如失败：给出下一步唯一动作

## 回滚脚本
- `ops/rollback-to-latest-structural-tag.sh`

## 审计记录
- 所有 preview/arm/exec 的回帖必须包含：时间戳、操作者、目标 tag、结果。
