---
description: "Prometheus O 阶段：计划 → MD + CSV 生成 + 审批门"
argument-hint: "<可选：任务/功能名称，用于文件命名>"
---

你现在处于 **Prometheus 计划模式（O 阶段）**。

## 上下文收集策略 ⚡

在制定计划前，必须先收集项目上下文。按以下优先级使用工具：

### 工具优先级

| 优先级 | 工具 | 用途 | 降级条件 |
|--------|------|------|----------|
| 1️⃣ | `ace-tool (mcp__ace-tool__search_context)` | 语义搜索、上下文理解、代码关系分析 | 连接失败/超时 |
| 2️⃣ | `rg` / `grep` | 精确模式匹配、关键字搜索 | ace-tool 不可用时 |
| 3️⃣ | `ReadFile` | 直接读取已知文件 | 作为补充或精确定位 |

### 降级策略

如果 ace-tool 不可用（连接失败、超时、返回错误）：

1. **记录降级状态**：在输出中标注 `⚠️ ace-tool 不可用，使用兜底方案`
2. **使用替代方案**：
   - 用 `rg "pattern" --type <lang>` 进行关键字搜索
   - 用 `find . -type f -name "*.ts"` 定位文件
   - 用 `ReadFile` 读取关键入口文件
3. **增加确认步骤**：对推断的上下文，在 O 阶段明确标注为"需确认"

## 概述

此命令执行完整的 Prometheus O 阶段：
1. 创建详细计划
2. 生成可追踪的 MD 和 CSV 文件
3. 请求批准后才能进入 D 阶段

---

## 第一步：计划制定

按照 Prometheus O 阶段要求产出：

### 1.1 计划（5-12 个具体步骤）
```markdown
## 计划：<功能/任务名称>

### 阶段 0：<标题>
<描述>

### 阶段 1：<标题>
<描述>

...
```

### 1.2 任务分解
```markdown
## 任务分解

- [ ] T001 <任务> — 完成标准：<验收条件>
- [ ] T002 <任务> — 完成标准：<验收条件>
...
```

### 1.3 变更文件
```markdown
## 变更文件

| 操作 | 文件路径 | 说明 |
|------|----------|------|
| 新增 | path/to/file | ... |
| 修改 | path/to/file | ... |
| 删除 | path/to/file | ... |
```

### 1.4 风险与回滚
```markdown
## 风险与回滚

| 风险 | 缓解措施 | 回滚策略 |
|------|----------|----------|
| ... | ... | ... |
```

---

## 第二步：生成计划 MD 文件

写入路径：`plan/<YYYY-MM-DD>-<slug>.md`

**MD 模板：**
```markdown
# 计划：<功能/任务名称>

> 生成时间：<时间戳>
> 状态：待审批

## 概要
<1-2 句概述>

## 阶段详情
<阶段 0-N 详细内容>

## 任务分解
<T001-T00N 及验收条件>

## 变更文件
<表格>

## 风险与回滚
<表格>

## 参考资料
- <相关文件、文档、issue>
```

---

## 第三步：生成 Issues CSV

写入路径：`issues/<YYYY-MM-DD_HH-mm-ss>-<slug>.csv`（快照）
同时更新：`issues/issues.csv`（当前汇总）

### CSV Schema（固定表头）
```
id,priority,phase,area,title,description,acceptance_criteria,test_mcp,review_initial_requirements,review_regression_requirements,dev_state,review_initial_state,review_regression_state,git_state,owner,refs,notes
```

### 字段说明

| 字段 | 说明 | 示例 |
|------|------|------|
| `id` | 唯一标识（`PREFIX-000`，按 10 递增） | `FEAT-010` |
| `priority` | `P0\|P1\|P2` | `P1` |
| `phase` | 来源阶段编号 | `1` 或 `2.1` |
| `area` | `backend\|frontend\|both` | `backend` |
| `title` | 一句话标题 | `添加用户认证接口` |
| `description` | 1-2 句，聚焦边界 | `实现 JWT 认证...` |
| `acceptance_criteria` | 可测试的验收标准 | `有效 token 返回 200` |
| `test_mcp` | 测试执行器 | `AUTOSERVER\|AUTOFRONTEND\|AUTOE2E` |
| `review_initial_requirements` | 开发时 Review 要点 | `检查错误处理` |
| `review_regression_requirements` | 最终回归要点 | `1000 用户负载测试` |
| `dev_state` | `未开始\|进行中\|已完成` | `未开始` |
| `review_initial_state` | 同上枚举 | `未开始` |
| `review_regression_state` | 同上枚举 | `未开始` |
| `git_state` | `未提交\|已提交` | `未提交` |
| `owner` | 留空（后续分配） | `` |
| `refs` | 文件引用 `path:line` | `plan/2024-01-01-auth.md:15` |
| `notes` | 自由备注 | `` |

### CSV 规则
- UTF-8 with BOM 编码
- 所有字段用双引号包裹
- 内部 `"` 转义为 `""`
- 默认状态：`未开始`，`git_state`：`未提交`

---

## 第四步：输出摘要

生成文件后，输出：

```
## 📋 计划已生成

### 创建的文件
- 计划 MD：`plan/<文件名>.md`
- Issues CSV（快照）：`issues/<文件名>.csv`
- Issues CSV（汇总）：`issues/issues.csv`

### 统计
- 阶段数：N
- 任务数：N
- 优先级分布：P0=X, P1=Y, P2=Z

### 下一步
**是否批准进入 D 阶段？**
- [ ] 是，开始实现
- [ ] 否，需要修改（请说明）
```

---

## 执行检查清单

1. [ ] 阅读上下文，理解需求
2. [ ] 生成 5-12 个阶段的计划
3. [ ] 创建带验收条件的任务分解
4. [ ] 列出变更文件
5. [ ] 识别风险和回滚策略
6. [ ] 写入 `plan/<date>-<slug>.md`
7. [ ] 写入 `issues/<timestamp>-<slug>.csv`（快照）
8. [ ] 更新 `issues/issues.csv`（汇总）
9. [ ] 输出摘要并请求审批

**⚠️ 在此处停止。未经明确批准，不得进入 D 阶段。**
