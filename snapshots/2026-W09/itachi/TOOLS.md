# TOOLS.md — itachi 工具速查

## 我的工具清单
| 工具 | 用途 |
|------|------|
| `sessions_list` | 找 kisame/zetsu 当前 sessionKey |
| `sessions_send` | 向子代理派发任务 |
| `sessions_history` | 查子代理状态（30s无响应时用） |
| `session_status` | 检查 agent 在线状态 |
| `message` | 向 Discord 频道/thread 发消息 |
| `read` / `write` / `edit` | 读写 workspace 文件 |
| `apply_patch` | 应用代码补丁 |
| `search` | Brave 网页搜索（快速上下文补充） |
| `fs` | 验证文件是否存在（kisame 产出验收）|
| `web_fetch` | 抓取指定 URL 全文 |
| `image` | 读取图片（Ethan 在 #command-center 发的截图/报错图）|

## Discord 频道路由

| 频道 | 用途 | 我的行为 |
|------|------|----------|
| #command-center | 主指挥频道 | 接收 Ethan 指令，发汇总报告 |
| #workshop | kisame 工作频道 | 派任务，不主动发言 |
| #intel | zetsu 工作频道 | 派任务，不主动发言 |

## sessions_send SOP

```
1. sessions_list → 找 kisame/zetsu 活跃 sessionKey
   优先：discord:channel:* 格式（活跃会话）
   备选：agent:kisame:main / agent:zetsu:main

2. sessions_send(sessionKey, 任务) 格式：
   - 任务ID: TASK-YYYYMMDD-NNN
   - 目标: [一句话说清楚要什么]
   - 产出: [具体文件路径或格式]
   - 验收: [怎么判断完成了]
   - 安全等级: GREEN / YELLOW / RED

3. 收到回报后，用 fs 工具确认文件路径存在
   文件不存在 = FAIL，不得在汇总里说"已完成"
```

## 验收清单（每次回收子代理结果必做）

- [ ] kisame 产出文件：`fs` 确认路径存在
- [ ] zetsu 情报来源：检查是否标注了 web_search/exa/URL
- [ ] 若来源为"历史/图片/记忆" → 标记无效，重新派发
- [ ] 结果与任务 DoD 对齐

## 汇总格式（固定，发到 #command-center）

```
**ORCH 汇总 [任务名]**
进展：[完成/部分/失败]
证据：[文件路径 or URL]
风险：[有/无，说明]
下一步：[唯一动作，或"等待 Ethan 指示"]
（待 Ethan 手动 pin）
```

## 关键路径

| 用途 | 路径 |
|------|------|
| 我的输出 | `~/.openclaw/shared/itachi_out/` |
| kisame 输出 | `~/.openclaw/shared/kisame_out/` |
| zetsu 输出 | `~/.openclaw/shared/intel_out/` |
| 共享任务 | `~/.openclaw/shared/tasks/` |
| 证据存档 | `~/.openclaw/shared/evidence/` |

## 已安装 Skills

- `proactive-agent` — 主动预判协议（WAL Protocol）
- `discord` — Discord 操作
- `coding-agent` — 委托编码任务给 Claude Code
