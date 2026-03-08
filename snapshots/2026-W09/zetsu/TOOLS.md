# TOOLS.md — zetsu 工具速查

## ⭐ Ontario Pay Hub 每日搜索任务（9:30 AM cron）

当收到 `ONTARIO-PAY-HUB 每日更新` 任务时，执行以下流程：

**Step 1 — 多维度搜索**（每次必须用全部 3 个查询）
```
web_search: Ontario job salary range CAD 2026 site:ca.indeed.com
web_search: Toronto compensation range CAD 2026 hiring new site:linkedin.com/jobs
web_search: "pay range" OR "salary range" Ontario employer CAD 2026 "per year"
```

**Step 2 — 数据验证标准（每条必须满足）**
- ✅ 地域：Ontario, Canada（必须含 ON / Toronto / Mississauga 等）
- ✅ 薪酬：明确 CAD min-max（如 $85,000–$120,000），拒绝模糊表述
- ✅ 日期：posted >= 2026-01-01
- ✅ source_url 必须是具体职位页（含 job ID 或职位名路径）
- ❌ 拒绝：无薪酬区间 / 非 Ontario / 时薪 / min >= max / **通用主页URL**

**⚠️ source_url 铁律：必须是具体职位页，禁止填写主页**
```
❌ 禁止: https://rbc.com/careers
❌ 禁止: https://ca.indeed.com/jobs
✅ 正确: https://ca.indeed.com/viewjob?jk=abc1234567890
✅ 正确: https://jobs.rbc.com/ca/en/job/R-0000123456/Software-Engineer
✅ 正确: https://ca.linkedin.com/jobs/view/3890123456
```
找不到具体 URL → **丢弃该条，不要填通用主页**

**Step 3 — 写入输出文件**
```bash
TODAY=$(date +%Y-%m-%d)
OUTPUT="/tmp/ontario-jobs-raw-$TODAY.txt"
# 格式（严格）：
# {"role":"Software Engineer","company":"Shopify","min":110000,"max":160000,"location":"Toronto, ON","source_url":"https://www.shopify.com/careers/senior-engineer-toronto_remote_full-time","posted":"2026-03-05"}
```

**Step 4 — 通知 kisame 运行更新脚本**
```bash
bash ~/ontario-pay-hub/scripts/update-jobs.sh
```

**质量自检（写文件前）**：每条 entry 必须有 role/company/min/max/source_url/posted，min < max，location 含 "ON"，**source_url 含 job ID 或职位名**

---

## ⭐ 历史数据补全任务（一次性）

当收到 `BULK-SEARCH-HISTORICAL` 任务时，阅读完整协议：
```bash
cat ~/ontario-pay-hub/scripts/zetsu-search-protocol.md
```
然后运行全部 24 组查询，目标 50+ 条真实数据，写入同一输出文件。

## 我的工具清单
| 工具 | 用途 |
|------|------|
| `web_search` | Brave Search（普通网页/新闻/产品）|
| `web_fetch` | 抓取特定 URL 全文 |
| `exa` | 神经语义搜索（文档/代码/论文）|
| `read` / `write` / `edit` | 读写 workspace 内文件 |
| `fs` | 浏览共享目录文件系统（workspaceOnly=false）|
| `sessions_list/send/history` | 与 itachi 通信，回报情报 |

## 搜索工具选择决策树

```
问题类型？

├─ 当前事件 / 新闻 / 价格 / 产品发布
│   → web_search (Brave)
│   示例：web_search("OpenRouter 最新价格 2026")

├─ 技术文档 / API Reference / 代码示例 / GitHub
│   → exa code.sh 或 search.sh
│   示例：bash ~/.openclaw/skills/exa/scripts/code.sh "openclaw config set syntax"

├─ 学术论文 / 深度研究报告
│   → exa search.sh --category research-paper
│   示例：bash ~/.openclaw/skills/exa/scripts/search.sh "LLM agent orchestration" 10 neural research-paper

├─ 已知 URL，需要全文
│   → web_fetch(url)
│   或：bash ~/.openclaw/skills/exa/scripts/content.sh "https://..."

├─ 重要情报（需要高可信度）
│   → Brave + Exa 双搜，交叉验证
│   有差异时：两个结果都呈现，说明差异
```

## Exa 完整用法

```bash
# 通用搜索
bash ~/.openclaw/skills/exa/scripts/search.sh "查询词" [数量=10] [类型=auto] [分类]
# 类型：auto | neural | fast | deep
# 分类：company | research-paper | news | github | tweet | pdf

# 代码/文档专用（优化过的 prompt）
bash ~/.openclaw/skills/exa/scripts/code.sh "查询词" [数量=10]

# 从 URL 提取全文
bash ~/.openclaw/skills/exa/scripts/content.sh "url1" "url2" ...

# 前提：export EXA_API_KEY="your-key"
# 申请：https://dashboard.exa.ai/api-keys
```

## 标准输出格式

每次情报回报必须包含：

```markdown
## 情报摘要
任务：[任务ID / 描述]
搜索时间：YYYY-MM-DD HH:MM
工具：[web_search / exa / web_fetch]

### 结论
[1-3句核心结论]

### 证据
- [要点] — [来源URL或工具名] ([日期])
- [要点] — [来源URL或工具名] ([日期])

### 可信度
[高 / 中 / 低] — [原因]

### 建议（给 itachi）
[下一步行动建议]
```

## 产出文件路径

```
~/.openclaw/shared/intel_out/bulletin-YYYY-MM-DD-HHMM.md   # 常规情报
~/.openclaw/shared/intel_out/factcheck-<id>.md              # 事实核查
~/.openclaw/shared/intel_out/summary-<title>.md             # 文档摘要
~/.openclaw/shared/intel_out/ecosystem-YYYY-MM-WW.md        # 生态监测
```

## 向 itachi 回报的格式

```
sessions_send(itachi_sessionKey, "
TASK-[ID] 情报完成
状态：Pass / Fail
产出：~/.openclaw/shared/intel_out/bulletin-YYYY-MM-DD-HHMM.md
摘要：[2-3句核心结论]
来源：[工具] + [URL数量]个来源
")
```

## 关键路径速查

| 用途 | 路径 |
|------|------|
| 我的输出 | `~/.openclaw/shared/intel_out/` |
| 共享工作区 | `~/.openclaw/shared/` |
| kisame 输出 | `~/.openclaw/shared/kisame_out/` |

## 已安装 Skills

- `exa` — 神经语义搜索（需 EXA_API_KEY）
- `skill-vetter` — 安装新 skill 前的安全审查协议
- `self-improving` — 自我反思 + 纠错循环
- `capability-evolver` — 能力进化引擎

## 备注

- **EXA_API_KEY**：已配置到 ~/.zshenv + ~/.zshrc，网关重启后生效
