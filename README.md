# open-claw-ops
## 2026-02-27 P0-S1 Canary (Browser-only)
结论：在 OpenClaw 2026.2.25 中，Discord allowlist 的官方做法是：先把目标 Server ID 加入 guild allowlist，并通过 channels.discord.dmPolicy / allowFrom / guilds.<id> 等配置键落地访问控制。
证据链接1：https://docs.openclaw.ai/channels/discord#recommended-set-up-a-guild-workspace（含“Add your server to the guild allowlist”）
证据链接2：https://docs.openclaw.ai/gateway/configuration-reference#discord（Discord 配置参考，含 dmPolicy、allowFrom、guilds 等键）
风险：若把 dmPolicy 设为 open 或 allowFrom 误配（如放开 "*"），会扩大未授权消息面；另需留意 guild/channel 级覆盖顺序。
回滚：移除/收紧对应 guilds.<id> 与 allowFrom 项，或将 dmPolicy 回退到 pairing，然后 openclaw gateway restart 使配置生效。
下一步：先在测试服只放行 1 个 guild + 1 个用户做 canary，验证通过后再扩展到生产频道。

## 2026-02-28 P0-S2 GitHub Read-only (KISAME_OK)

《KISAME_OK》

用途摘要（3 行）
1) runbooks/discord-allowlist.md：定义 Discord 触发面最小化的 P0 操作手册（allowlist + requireMention + loopback-only），并给出可验证、可回滚步骤。
2) skills-audit.md：记录技能/能力变更的审计台账（模式、范围、权限、证据、回滚），用于追溯与风控。
3) 今日进度：已完成 P0-S1 Canary 依据确认与 runbook/audit 文档读取输入，当前可进入按 runbook 执行与留痕阶段。

Runbook 最关键 3 个可回滚步骤（目的/操作/验证/回滚）
1) 目的：先收紧全局策略。｜操作：groupPolicy=allowlist + openclaw gateway restart。｜验证：openclaw status 安全审计无 critical。｜回滚：恢复 ~/.openclaw/openclaw.json.bak.<timestamp> 后重启 gateway。
2) 目的：只放行目标 guild/channel。｜操作：写入 channels.discord.guilds（最小集合）并设 requireMention=true，随后重启 gateway。｜验证：仅在允许频道且被 mention 时响应。｜回滚：删除该 guild 条目或恢复备份并重启。
3) 目的：保障变更可追踪。｜操作：在 skills-audit.md 追加一行（模式/范围/证据/回滚）。｜验证：审计表新增记录且字段完整。｜回滚：将模式回退为 “manual browsing only” 并记录回退条目。
