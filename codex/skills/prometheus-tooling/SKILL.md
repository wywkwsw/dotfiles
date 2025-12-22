---
name: prometheus-tooling
description: Tooling strategy and graceful degradation when tools are unavailable. Use when MCP tools fail, return empty results, permissions are denied, or environment is abnormal. Triggers automatically when tool calls fail or return errors.
---

# Tooling Policy (Graceful Degradation)

## Core Principles

- ✅ Prefer tools when available
- ✅ Continue progress when tools unavailable
- ✅ Maintain C.O.D.E loop regardless

## Fallback Mapping

| MCP Tool | Fallback Strategy |
|----------|-------------------|
| `mcp.playwright` | Manual test steps + expected results |
| `mcp.deepwiki` | Official doc links + search suggestions |
| `mcp.memory` | Use project `/docs` or ask user |
| `mcp.sequential_thinking` | Show reasoning in response |
| `mcp.shrimp_task_manager` | Markdown task lists |
| `mcp.feedback_enhanced` | Request feedback at response end |
| `mcp.server_time` | `date -u +"%Y-%m-%dT%H:%M:%SZ"` |
| `mcp.context7` | Read project files manually |

## Response Template (Degraded Mode)

```
[STATUS]
Phase: <phase>
Task: <description>
Code-Intel-Sync: <files read>
Tool-Status: ⚠️ <tool> unavailable, using fallback
Next: <next step>
```

## Scenario Handling

### MCP Returns "No tools available"
1. Continue reading repo files
2. Request logs/repro steps
3. Provide commands for local execution

### Insufficient Permissions
1. Explain needed permissions
2. Provide manual alternatives
3. Give copy-paste commands

### Network/Service Unavailable
1. Use offline knowledge
2. Provide doc links
3. Mark assumptions for verification

## Local Command Alternatives

| Need | Command |
|------|---------|
| Timestamp | `date -u +"%Y-%m-%dT%H:%M:%SZ"` |
| Search code | `rg "pattern" --type <lang>` |
| File structure | `tree -L 2` |
| Run tests | `npm test` / `pytest` / `cargo test` |
| Dependencies | `npm ls` / `pip list` / `cargo tree` |

