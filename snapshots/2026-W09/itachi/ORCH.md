# ORCH.md — Multi-agent Orchestration (v2)

## ORCH-1：标准自动闭环（派工 → 触发 → 回收 → 汇总）

**目标**：itachi 拆解任务，通过 `sessions_send` 派发给 kisame/zetsu，收到结果后在 #command-center 汇总一条 ≤1200 字的《ORCH-1 汇总》。

### 输入（Ethan 在 command-center 发给 itachi）
- 任务目标（1 句话）
- T1（kisame/执行）：执行/产出要求
- T2（zetsu/情报）：核对/证据要求
- DoD（完成定义）
- 安全等级：GREEN / YELLOW / RED（RED 必须 fuse + “FUSE ARMED”）

### itachi 的执行规则（必须遵守）

**Step 1 — Locate（定位）**
1. `sessions_list` → 找到 kisame 和 zetsu 当前活跃的 sessionKey
2. 优先选 `discord:channel:*` 格式的 sessionKey（活跃会话）；无则用 `agent:kisame:main` / `agent:zetsu:main`

**Step 2 — Dispatch（派发）**
1. `sessions_send(sessionKey_kisame, task_T1)` — 包含：任务ID + 目标产出格式 + DoD + 截止条件
2. `sessions_send(sessionKey_zetsu, task_T2)` — 同上
3. ⚠️ 不得使用 Discord @mention 触发（不可靠，已废弃）

**Step 3 — Collect（回收）**
1. 等待 kisame / zetsu 各自在频道回复（或通过 sessions_send 回报）
2. 若 30s 无响应，用 `sessions_history(sessionKey)` 主动拉取状态
3. 若 kisame/zetsu 需要 Ethan 审批，在 #command-center 转告，附上 requestId
4. **kisame 产出文件验收（必须）**：收到 kisame 回报后，用 `fs` 工具确认 DoD 指定的文件路径实际存在。文件不存在 = FAIL，必须在 #command-center 明确标注 `⚠️ FAIL: <文件路径> 未生成`，不得在汇总里声称已完成。
5. **zetsu 情报来源验收**：zetsu 的回报必须注明情报来源（`web_search` / `web_fetch` / URL）。若来源标注为「历史/图片/对话记忆」，视为无效情报，需重新派发并明确要求实时搜索。

**Step 4 — Summarize（汇总）**
在 #command-center 输出《ORCH-1 汇总》（≤1200 字），末尾标注：`待 Ethan 手动 pin`

**禁止**：不得声称已 pin；Pinned 由 Ethan 手动完成。

### 汇总格式（固定）
**《ORCH-1 汇总》**
- 进展：
- 证据/链接：
- 风险：
- 下一步（唯一动作）：
（待 Ethan 手动 pin）

