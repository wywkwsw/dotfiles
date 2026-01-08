---
name: prometheus-tooling
version: 1.0.0
description: Tooling strategy and fallback solutions. Use when tools are unavailable, permissions are restricted, or environment is abnormal.
priority: fallback
triggers: [tool unavailable, tool failure, permission denied, environment issues]
---

# Tooling Policy (Graceful Degradation)

## Core Principles

- ✅ Prefer tools when available and helpful
- ✅ Continue progress when tools are unavailable—don't block
- ✅ Always maintain the C.O.D.E loop and approval gate

---

## Fallback Mapping Table

### Code Context Tools (⚡ 优先级最高)

| Tool | Fallback Strategy | Commands |
|------|-------------------|----------|
| Semantic Search | 使用 rg/grep + ReadFile 组合 | `rg "pattern" --type <lang> -n` |

**语义搜索降级详细策略：**
1. `rg "symbol" --type <lang> -n` — 符号定位
2. `rg "import.*from" --type ts` — 依赖追踪  
3. `find . -type f -name "*.ts"` — 文件定位
4. Read File — 读取定位到的文件

### Other Tools

| Tool | Fallback Strategy |
|------|-------------------|
| Browser automation | Provide manual test steps + expected results |
| Documentation lookup | Reference official doc links + search suggestions |
| Memory/knowledge graph | Use project `/docs` or ask user to record |
| Task manager | Use Markdown task lists |
| Time service | Use system command `date` or ask user to provide |

---

## Response Template When Tools Unavailable

```markdown
[STATUS]
Phase: <current phase>
Task: <task description>
Code-Intel-Sync: <files read>
Tool-Status: ⚠️ <tool name> unavailable, using fallback strategy
Next: <next step>
```

---

## Common Scenario Handling

### Scenario 1: Tool Reports "No tools available"

1. Continue reading repo files
2. Request logs/repro steps
3. Provide commands user can run locally

### Scenario 2: Insufficient Permissions

1. Explain what permissions are needed
2. Provide alternatives (user manual execution)
3. Provide commands for user to copy-paste

### Scenario 3: Network/External Service Unavailable

1. Use local cache or offline knowledge
2. Provide doc links for user to check
3. Mark assumptions that need later verification

---

## Local Command Alternatives

| Need | Alternative Command |
|------|---------------------|
| Get timestamp | `date -u +"%Y-%m-%dT%H:%M:%SZ"` |
| Search code | `rg "pattern" --type <lang>` |
| View file structure | `tree -L 2` or `find . -type f -name "*.ts"` |
| Run tests | `npm test` / `pytest` / `cargo test` |
| Check dependencies | `npm ls` / `pip list` / `cargo tree` |
