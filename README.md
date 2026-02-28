# open-claw-ops
## 2026-02-27 P0-S1 Canary (Browser-only)
结论：在 OpenClaw 2026.2.25 中，Discord allowlist 的官方做法是：先把目标 Server ID 加入 guild allowlist，并通过 channels.discord.dmPolicy / allowFrom / guilds.<id> 等配置键落地访问控制。
证据链接1：https://docs.openclaw.ai/channels/discord#recommended-set-up-a-guild-workspace（含“Add your server to the guild allowlist”）
证据链接2：https://docs.openclaw.ai/gateway/configuration-reference#discord（Discord 配置参考，含 dmPolicy、allowFrom、guilds 等键）
风险：若把 dmPolicy 设为 open 或 allowFrom 误配（如放开 "*"），会扩大未授权消息面；另需留意 guild/channel 级覆盖顺序。
回滚：移除/收紧对应 guilds.<id> 与 allowFrom 项，或将 dmPolicy 回退到 pairing，然后 openclaw gateway restart 使配置生效。
下一步：先在测试服只放行 1 个 guild + 1 个用户做 canary，验证通过后再扩展到生产频道。
