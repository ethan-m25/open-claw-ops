# P0-S2 text-in-thread fallback (STABLE)

## Goal
将 “text-in-thread fallback” 固化为可重复执行、可验收的 Runbook 步骤（不依赖 URL 抓取）。

## Steps
1) 输入：在 thread 中粘贴原文（来源可为 GitHub 文件或工具输出）。
2) 输出：生成《KISAME_OK》单条版（目的/操作/验证/回滚）。
3) 留痕：在 skills-audit.md 追加一行记录（mode=STABLE, scope, artifacts, rollback）。

## DoD (验收)
- 在受限权限下完成 thread 文本回退
- 输出可被人工复核（时间/执行人/结果记录清晰）
- 不引入额外权限扩张

## Rollback
回退为 “manual paste only” 并在 skills-audit.md 追加回退记录。
