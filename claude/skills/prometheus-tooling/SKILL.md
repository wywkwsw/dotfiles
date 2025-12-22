---
name: prometheus-tooling
version: 1.0.0
description: Tooling strategy and fallback solutions. Use when MCP tools are unavailable, permissions are restricted, or environment is abnormal.
priority: fallback
triggers: [tool unavailable, MCP failure, permission denied, environment issues]
---

# Tooling Policy (Graceful Degradation)

## Core Principles

- ✅ Prefer tools when available and helpful
- ✅ Continue progress when tools are unavailable—don't block
- ✅ Always maintain the C.O.D.E loop and approval gate

---

## Fallback Mapping Table

| MCP Tool | Fallback Strategy |
|----------|-------------------|
| `mcp.playwright` | Provide manual test steps + expected results |
| `mcp.deepwiki` | Reference official doc links + search suggestions |
| `mcp.memory` | Use project `/docs` or ask user to record |
| `mcp.sequential_thinking` | Show reasoning process in response |
| `mcp.shrimp_task_manager` | Use Markdown task lists |
| `mcp.feedback_enhanced` | Request feedback directly at response end |
| `mcp.server_time` | Use system command `date` or ask user to provide |
| `mcp.context7` | Manually read project files |

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

### Scenario 1: MCP Server Reports "No tools available"

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
