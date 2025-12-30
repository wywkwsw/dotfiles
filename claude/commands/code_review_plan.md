---
description: 对项目进行 Code Review 并生成 plan/*.md 执行计划（支持三种审查范围）[SCOPE=global|unpushed|uncommitted] [FOCUS=<可选聚焦领域>]
argument-hint: "[SCOPE=global|unpushed|uncommitted] [FOCUS=<可选聚焦领域>]"

---

你现在处于「Code Review → Plan 模式」。

## 上下文收集策略 ⚡

Code Review 需要深入理解代码结构和依赖关系。

### 工具优先级（必须遵守）

| 优先级 | 工具 | 用途 | 降级条件 |
|--------|------|------|----------|
| 1️⃣ | `ace-tool (mcp__ace-tool__search_context)` | 理解架构、查找依赖关系、识别模式 | 连接失败/超时 |
| 2️⃣ | `rg` / `grep` | 精确模式匹配、死代码检测 | ace-tool 不可用时 |
| 3️⃣ | `ReadFile` | 读取具体文件内容 | 作为补充 |

### 降级策略

如果 ace-tool 不可用：

1. **记录状态**：在 Plan 文件开头标注 `⚠️ 注意：本次 Review 未使用 ace-tool，依赖关系分析可能不完整`
2. **替代方案**：
   - `rg "import|require" --type ts` 分析依赖
   - `rg "export" --type ts` 查找公共 API
   - `rg "TODO|FIXME|HACK" --type-not json` 查找技术债务
3. **聚焦建议**：在 global 范围下，优先使用 FOCUS 缩小审查范围以提高准确性

目标：根据指定的审查范围对代码进行 Code Review，识别问题与改进点，并生成结构化的 `plan/*.md` 执行计划文件，供后续 `/prompts:plan_to_issues_csv` 消费。

> 核心原则：Code Review 不是挑刺，而是发现**真正需要解决的问题**和**可落地的改进机会**。  
> Plan 文件是"技术债务/改进项的契约"，不是流水账。

## 一、审查范围（SCOPE）

根据 `$SCOPE` 参数选择审查范围（默认为 `uncommitted`）：

### 1. `global` — 全局项目审查

对整个项目进行全面 Code Review，适用于：
- 新接手项目的全面摸底
- 定期技术债务盘点
- 架构/质量专项审计

**获取范围命令：**
```bash
# 列出所有被 git 跟踪的源文件（排除 node_modules、dist 等）
git ls-files | grep -E '\.(ts|tsx|js|jsx|py|go|rs|java|swift|kt|vue|svelte|css|scss|md)$'
```

### 2. `unpushed` — 未推送变更审查

对已 commit 但尚未 push 到远程仓库的变更进行 Code Review，适用于：
- Push 前的自检
- PR 前的预审
- 批量 commit 后的复查

**获取范围命令：**
```bash
# 获取本地领先于远程的 commit 列表
git log @{u}..HEAD --oneline

# 获取这些 commit 中变更的文件
git diff --name-only @{u}..HEAD

# 查看具体变更内容
git diff @{u}..HEAD
```

### 3. `uncommitted` — 未提交变更审查（默认）

对当前工作区中已修改但未 commit 的文件进行 Code Review，适用于：
- Commit 前的自检
- 开发过程中的即时审查
- 修复 bug 后的验证

**获取范围命令：**
```bash
# 已暂存的文件
git diff --name-only --cached

# 未暂存的修改文件
git diff --name-only

# 未跟踪的新文件
git ls-files --others --exclude-standard

# 查看所有未提交的变更内容
git diff HEAD
```

## 二、总体行为约定（必须遵守）

1. **必须先执行 git 命令**获取实际的文件/变更列表，不得凭空猜测。
2. **必须阅读实际代码**后再给出审查意见，不得仅凭文件名推断。
3. 审查发现必须分类、分优先级，并给出**可操作的改进建议**。
4. 生成的 plan 文件必须可被 `/prompts:plan_to_issues_csv` 直接消费。
5. 如果 `$FOCUS` 非空，优先关注该领域（如 `FOCUS=性能`、`FOCUS=安全`、`FOCUS=可读性`）。

## 三、Code Review 检查清单

按以下维度进行审查（根据 FOCUS 可调整权重）：

### 3.1 架构与设计
- [ ] 模块划分是否合理（高内聚、低耦合）
- [ ] 是否存在循环依赖
- [ ] 抽象层次是否恰当（过度抽象/抽象不足）
- [ ] 是否遵循 SOLID 原则

### 3.2 代码质量
- [ ] 命名是否清晰（变量/函数/类/文件）
- [ ] 函数长度是否合理（建议 < 50 行）
- [ ] 是否存在重复代码（DRY 违规）
- [ ] 是否存在魔法数字/硬编码
- [ ] 注释是否充分且有价值

### 3.3 错误处理
- [ ] 是否有适当的错误处理/try-catch
- [ ] 错误信息是否有助于调试
- [ ] 边界条件是否覆盖（null/undefined/空数组等）
- [ ] 异步操作是否正确处理错误

### 3.4 性能
- [ ] 是否存在 N+1 查询
- [ ] 是否有不必要的重复计算
- [ ] 是否有内存泄漏风险
- [ ] 大列表是否考虑分页/虚拟化

### 3.5 安全
- [ ] 用户输入是否验证/转义
- [ ] 是否存在 SQL 注入/XSS 风险
- [ ] 敏感信息是否硬编码
- [ ] 权限检查是否完整

### 3.6 可测试性
- [ ] 函数是否便于单元测试
- [ ] 依赖是否可注入/mock
- [ ] 是否存在隐式全局状态

### 3.7 可维护性
- [ ] 类型定义是否完整（TS/类型注解）
- [ ] 是否有过时的 TODO/FIXME
- [ ] 依赖版本是否合理
- [ ] 是否有废弃/未使用的代码

## 四、Plan 文件输出格式

生成的 plan 文件必须符合以下结构：

```markdown
# Code Review Plan: <简短标题>

> 审查范围：<global|unpushed|uncommitted>  
> 审查时间：<YYYY-MM-DD HH:mm>  
> 聚焦领域：<FOCUS 或 "全面审查">

## 📊 概览

| 指标 | 数值 |
|------|------|
| 审查文件数 | N |
| 发现问题数 | N |
| 严重程度分布 | 🔴 N / 🟡 N / 🟢 N |

## 🔴 Phase 0: 紧急/阻断性问题

> 必须立即修复，阻塞发布或存在安全风险

### 0.1 <问题标题>
- **文件**: `path/to/file.ts:L10-L20`
- **问题描述**: ...
- **影响范围**: ...
- **建议修复**: ...
- **验收标准**: ...

## 🟡 Phase 1: 重要改进项

> 应尽快处理，影响代码质量或可维护性

### 1.1 <问题标题>
...

## 🟢 Phase 2: 建议优化项

> 锦上添花，有时间时处理

### 2.1 <问题标题>
...

## 📎 参考

- 涉及文件清单
- 相关文档/规范链接
```

## 五、文件命名与存储

1. 目录：确保项目根目录下存在 `plan/`（不存在则创建）。
2. 命名规则：`plan/YYYY-MM-DD_code-review-<scope>.md`
   - 示例：`plan/2025-01-15_code-review-unpushed.md`
3. 如果同一天多次审查，追加序号：`...-unpushed-2.md`

## 六、执行步骤

你应按以下步骤执行：

### Step 1: 确定审查范围
1. 解析 `$SCOPE` 参数（默认 `uncommitted`）
2. 执行对应的 git 命令获取文件/变更列表
3. 若无变更（如 `unpushed` 但本地与远程同步），提示用户并询问是否切换范围

### Step 2: 读取与分析代码
1. 读取范围内的所有相关文件
2. 对于 `global` 范围，优先关注：
   - 入口文件（index/main/app）
   - 配置文件
   - 核心业务模块
   - 公共工具函数
3. 对于 `unpushed`/`uncommitted`，重点审查变更部分及其上下文

### Step 3: 执行 Code Review
1. 按检查清单逐项审查
2. 记录发现的问题，标注严重程度
3. 为每个问题提出可操作的修复建议

### Step 4: 生成 Plan 文件
1. 按模板整理审查结果
2. 写入 `plan/` 目录
3. 输出简要总结

## 七、对话内输出格式

完成后，在对话中输出：

```
✅ Code Review 完成

📁 Plan 文件：plan/YYYY-MM-DD_code-review-<scope>.md
📊 审查范围：<scope>（N 个文件）
🔍 发现问题：🔴 N / 🟡 N / 🟢 N

下一步：
- 执行 `/prompts:plan_to_issues_csv` 将 plan 转为可追踪的 issues
- 或直接开始处理 Phase 0 的紧急问题
```

## 八、边界情况处理

1. **无变更**：提示用户当前范围无变更，建议切换范围或确认分支。
2. **文件过多（global 超过 100 个）**：
   - 先输出文件清单让用户确认
   - 或建议使用 `FOCUS` 缩小范围
3. **二进制/大文件**：跳过，在报告中注明。
4. **远程分支不存在（unpushed）**：提示用户设置上游分支或使用其他范围。
