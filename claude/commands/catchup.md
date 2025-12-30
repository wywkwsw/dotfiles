---
description: 通过读取当前分支上所有未提交的变更（已暂存+未暂存+未跟踪）来继续未完成的工作，然后执行缺失的部分。
argument-hint: [FOCUS="<what to finish>"] [MODE=continue|plan|recap]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git ls-files:*), Bash(git rev-parse:*), Read(*), Write(*)
---

## 上下文收集策略 ⚡

恢复上下文时需要理解未完成工作的意图。

### 工具优先级

| 优先级 | 工具 | 用途 | 降级条件 |
|--------|------|------|----------|
| 1️⃣ | `ace-tool (mcp__ace-tool__search_context)` | 理解修改意图、查找相关代码 | 连接失败/超时 |
| 2️⃣ | `rg` / `grep` | 搜索 TODO/FIXME/WIP 标记 | ace-tool 不可用时 |
| 3️⃣ | `ReadFile` + `git diff` | 读取变更内容 | 基础手段 |

### 降级策略

如果 ace-tool 不可用：

1. **标注状态**：在输出中标注 `⚠️ ace-tool 不可用，意图推断可能不完整`
2. **替代方案**：
   - `rg "TODO|FIXME|WIP" <changed_files>` 查找标记
   - `git diff HEAD` 分析变更内容
   - 读取变更文件的完整上下文
3. **增加确认**：在 MODE=continue 时，先输出推断的意图让用户确认

---

## Snapshot (auto; you do not need to run any VCS commands manually)
- Branch + HEAD: !`git rev-parse --abbrev-ref HEAD && git rev-parse --short HEAD`
- Working tree summary: !`git status -sb`

## Uncommitted file inventory (MUST treat this as the source of truth)
- Staged files: !`git diff --name-only --cached`
- Unstaged files: !`git diff --name-only`
- Untracked files: !`git ls-files --others --exclude-standard`

## Your task (MODE=$MODE, FOCUS=$FOCUS)
You are resuming after context loss (compact/clear). Do NOT ask the user for Git outputs.

1) Build the “Uncommitted Set” = union(staged + unstaged + untracked).
2) Read **every file** in that set from disk (current working tree).
   - If a file is huge/binary, summarize it instead of dumping it.
3) Infer the unfinished requirements by scanning:
   - TODO/FIXME/WIP markers
   - partially implemented functions, missing exports, unfinished UI flows
   - failing tests or missing test coverage clues
4) MODE behavior:
   - recap: only summarize what’s going on + next steps.
   - plan: propose an execution plan + verification commands.
   - continue (default): implement the missing parts now.
5) While continuing:
   - Keep changes minimal and consistent with existing code style.
   - If multiple plausible intents exist, pick the most consistent one and proceed, noting assumptions.
6) End with:
   - what you changed (by file)
   - what remains (if anything)
   - exact verification steps to run locally