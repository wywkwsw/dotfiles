---

name: prometheus-core
version: 5.1.1
description: Prometheus core workflow. Use for any non-trivial development task including feature implementation, refactoring, architecture design, and code review.
priority: required

## Task Complexity Assessment (FIRST STEP)

**Before ANY action, quickly assess complexity:**


| Factor              | Simple                       | Complex                           |
| ------------------- | ---------------------------- | --------------------------------- |
| Lines changed       | < 30                         | > 30                              |
| Files affected      | 1                            | Multiple                          |
| Architecture impact | None                         | Structural                        |
| Risk level          | Low                          | High                              |
| Dependencies        | No changes                   | Adds/modifies                     |
| User signals        | "fix", "quick", "just do it" | "design", "refactor", "implement" |


### Decision Matrix

```
SIMPLE (≥4 Simple factors)     →  Fast Path
COMPLEX (≥3 Complex factors)   →  Full C.O.D.E Loop
UNCERTAIN                      →  Ask user or default to C.O.D.E
```

---

## Fast Path (Simple Tasks)

For simple tasks, execute directly:

1. Read relevant code (Context-First still applies)
2. Make the change
3. Briefly explain what was done
4. Provide verification if applicable

**No [STATUS] header. No approval gate. Just do it.**

### Fast Path Examples

- Fix typo or syntax error
- Add/remove single log statement
- Rename variable (single file)
- Update config value
- Small obvious bug fix
- Add simple comment

---

## Full C.O.D.E Loop (Complex Tasks)

### Response Header (Required)

```
[STATUS]
Phase: C | O | D | E
Task: <one line description>
Code-Intel-Sync: <files read/searched>
Next: <next action or question>
```

### C — Contextualize & Clarify

1. **Restate the goal**: Paraphrase user's goal, constraints, success criteria
2. **Build Code-Intel-Map**: Understand project by reading actual code
3. **Fill gaps**: Request missing info (logs, repro steps, stack traces)

### O — Outline & Architect ⚠️ Approval Gate

Produce:

1. **Plan**: 5-12 concrete steps
2. **Task breakdown**: Use template below
3. **Files to change**: List new/modify/delete
4. **Risks & rollback**: Identify risks and rollback strategies

**Then STOP and ask: "Approve to proceed to D?"**

#### Task Breakdown Template

```
- [ ] T001 <task> — Done when: <criteria>
- [ ] T002 <task> — Done when: <criteria>
```

### D — Develop & Debug

- ✅ Only implement approved tasks
- ✅ Keep diffs small and reviewable
- ✅ Add/update tests for behavior changes
- ✅ Provide verification commands

### E — Evaluate & Evolve

- 📝 Summarize what changed, why, and how to verify
- 🔄 Request next instructions or feedback

---

## Context-First Principle (Highest Priority)

- ❌ **NEVER** infer file purpose or variable meaning from names
- ✅ **MUST** understand code by reading implementation and relationships
- ✅ Support multilingual naming (English, Chinese, abbreviations)

---

## Engineering Principles (Aether Engineering)


| Principle                   | Description                              |
| --------------------------- | ---------------------------------------- |
| KISS                        | Keep it simple                           |
| DRY                         | Don't repeat yourself                    |
| YAGNI                       | Don't implement unneeded features        |
| SOLID                       | Single responsibility, Open-closed, etc. |
| High Cohesion, Low Coupling | Clear module boundaries                  |


---

## Tool Usage Priority ⚡

### Code Context Tools (按优先级使用)


| Priority | Tool                                       | Use For            | Fallback Trigger |
| -------- | ------------------------------------------ | ------------------ | ---------------- |
| 1️⃣      | `ace-tool (mcp__ace-tool__search_context)` | 语义搜索、代码关系分析、跨文件上下文 | 连接失败/超时/错误       |
| 2️⃣      | `rg` / `grep`                              | 精确模式匹配、符号定位        | ace-tool 不可用时    |
| 3️⃣      | `ReadFile`                                 | 读取具体文件内容           | 作为补充手段           |


### ace-tool Fallback Strategy

当 ace-tool 不可用时：

1. **标记状态**：输出 `⚠️ ace-tool unavailable, using fallback`
2. **替代方案**：
  - `rg "pattern" --type <lang> -n` 带行号搜索
  - `rg "import.*from" --type ts` 追踪依赖
  - `find . -type f -name "*.ts"` 定位文件
3. **增加验证**：重构操作必须用 `rg` 二次确认所有用法
4. **标注风险**：依赖推断的结论标为 "needs confirmation"

### Other MCP Tools


| Tool                      | Purpose                                   |
| ------------------------- | ----------------------------------------- |
| `mcp.context7`            | Check latest technical documentation      |
| `mcp.deepwiki`            | Verify if knowledge is outdated           |
| `mcp.sequential_thinking` | Deep reasoning for complex problems       |
| `mcp.shrimp_task_manager` | Task breakdown and management             |
| `mcp.memory`              | Store and retrieve experiential knowledge |
| `mcp.feedback_enhanced`   | Collect user feedback                     |


