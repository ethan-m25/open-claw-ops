《MASTER PLAN v0.7 — Roadmap（阶段 / 当前稳态 / 跨频道派工）》

【当前稳态（STABLE）】
    •    Discord：allowlist + requireMention（仅指定 guild + channels）
    •    Models：Primary=OpenAI Codex OAuth；Fallback=Gemini（Codex cooldown 时可接管）
    •    Ops：open-claw-ops 已落盘；Heartbeat backlog sweep（每日）+ memory proposal（每周）已跑通
    •    Browser：openclaw browser profile 可 snapshot（Browser-only canary 已通过）

【阶段路线（大方向）】
    •    P0（完成）：安全与可用性闭环（最小暴露面 + 可回滚）
    •    P1（主线进行中）：自主运维闭环
    •    Backlog（真相源）→ Next Unique Action（每日自动产出）→ 落盘（ops repo）→ 审计（skills-audit/ops-changelog）
    •    Memory proposal（每周提案）→ Discord 提醒 → 人工批准写入 MEMORY.md（安全边界）
    •    P2（按需扩展）：更强模型（Claude/Anthropic）、网页检索/证据链输出、长期记忆自动沉淀等
    •    原则：先 canary、白名单域名、可回滚；不为能力牺牲安全
    •    P3（规模化协作）：更复杂的多 agent 编排与任务流水线
    •    原则：仍最小权限、仍可回滚、仍以“人类审批 RED”为核心

【跨频道派工模板（复制到 workshop / intel / DM 都有效）】
按权威 thread pinned 的《MASTER PLAN v0.7（消息1+消息2）》+ 最新 Checkpoint 执行。
输出可长但必须结构化：结论/证据/风险/下一步唯一动作/回滚。
对我只给“下一步唯一动作”；agent 在非 RED 情况下可自跑多步闭环推进。
任何 RED：先给 FUSE，等我发 FUSE ARMED 再执行。
若读不到 pinned：先要求我粘贴（消息1+2）摘要或提供可读的 repo 文件路径，再继续。

【推进节奏建议】
    •    能让 agent 在 open-claw-ops 自己完成的（写脚本/修 bug/提 PR/落盘/自测）→ 优先让它自己跑
    •    需要我做的 → 必须压缩成 1 条“下一步唯一动作”，别让我在 Terminal 里做多步链路
