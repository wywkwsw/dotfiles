---
name: prometheus-ace
version: 1.0.0
description: Augment Code Context Engine (ACE) MCP integration. Use for codebase-wide semantic search, context retrieval, and intelligent code understanding.
priority: conditional
triggers: [context, codebase search, semantic search, find usage, code understanding, augment]
---

# Augment Code Context Engine (ACE)

## Overview

ACE is a powerful context engine that provides semantic understanding of your codebase. Use it for intelligent code search, usage finding, and context retrieval beyond simple grep.

---

## MCP Configuration

```json
{
  "ace-tool": {
    "command": "ace-tool",
    "args": [
      "--base-url", "https://acemcp.heroman.wtf/relay/",
      "--token", "ace_755ab731f91a954f2c9ec9ab82640c58fa442591"
    ]
  }
}
```

---

## When to Use ACE

| Scenario | Use ACE | Alternative |
|----------|---------|-------------|
| Semantic code search | ✅ | - |
| Find all usages of a function/class | ✅ | `rg` for simple cases |
| Understand code relationships | ✅ | - |
| Cross-file context gathering | ✅ | Manual file reading |
| Simple text/pattern search | ❌ | Use `rg` or `Grep` |
| Single file reading | ❌ | Use `ReadFile` |

---

## ACE Tool Capabilities

### 1. Semantic Search
Find code by meaning, not just text matching.

**Use when:**
- Looking for implementations of a concept
- Finding related code across the codebase
- Understanding how a feature is implemented

### 2. Usage Finding
Find all references to symbols, functions, classes.

**Use when:**
- Refactoring and need to update all usages
- Understanding impact of a change
- Tracing data flow

### 3. Context Retrieval
Get relevant context for a specific task.

**Use when:**
- Starting work on an unfamiliar area
- Need to understand dependencies
- Building Code-Intel-Map (Prometheus C phase)

---

## Integration with Prometheus Workflow

### C Phase (Contextualize)
```
1. Use ACE for broad codebase understanding
2. Identify relevant files and relationships
3. Build comprehensive Code-Intel-Map
```

### O Phase (Outline)
```
1. Use ACE to find existing patterns
2. Check for similar implementations
3. Identify files that need modification
```

### D Phase (Develop)
```
1. Use ACE to find all usages before refactoring
2. Verify no missing references
3. Check for breaking changes
```

---

## Usage Priority

When gathering context, use tools in this order:

```
1. ACE (semantic search)     → Broad understanding
2. Grep/rg (pattern search)  → Specific text patterns
3. ReadFile                  → Detailed file content
4. mcp.context7              → External documentation
5. mcp.deepwiki              → Knowledge verification
```

---

## Best Practices

### Do ✅
- Use ACE early in C phase for codebase exploration
- Combine ACE results with targeted file reads
- Use ACE to verify refactoring completeness

### Don't ❌
- Use ACE for simple keyword searches (use `rg`)
- Over-rely on ACE when files are already known
- Skip ACE results review before making changes

---

## Fallback Strategy

If ACE is unavailable:

| ACE Feature | Fallback |
|-------------|----------|
| Semantic search | `mcp.SemanticSearch` or manual exploration |
| Usage finding | `rg "symbol"` with file type filters |
| Context retrieval | Manual file reading + `Grep` |

---

## Example Queries

### Finding implementations
```
"How is user authentication implemented?"
"Where is the payment processing logic?"
```

### Finding usages
```
"Find all usages of UserService class"
"Where is the fetchData function called?"
```

### Understanding relationships
```
"What components depend on the auth module?"
"How does data flow from API to UI?"
```
