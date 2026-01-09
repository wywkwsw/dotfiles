---
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

## Usage Priority ⚡ (MUST FOLLOW)

**ace-tool 是代码上下文获取的首选工具。**

| Priority | Tool | Use For | Fallback Trigger |
|----------|------|---------|------------------|
| 1️⃣ | `ace-tool (mcp__ace-tool__search_context)` | 语义搜索、代码关系、广泛理解 | 连接失败/超时/错误 |
| 2️⃣ | `rg` / `grep` | 精确模式匹配、符号定位 | ace-tool 不可用时 |
| 3️⃣ | `ReadFile` | 读取具体文件内容 | 作为补充手段 |
| 4️⃣ | `mcp.context7` | 外部技术文档 | 需要框架/库知识时 |
| 5️⃣ | `mcp.deepwiki` | 知识验证 | 需要验证信息时 |

### 强制规则

- ✅ **每次需要理解代码时，必须先尝试 ace-tool**
- ✅ 仅当 ace-tool 失败后才使用 rg/grep 降级
- ✅ ReadFile 用于读取 ace-tool 定位到的具体文件
- ❌ 禁止跳过 ace-tool 直接使用 ReadFile 进行探索

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

## Fallback Strategy ⚠️

**当 ace-tool 不可用时（连接失败、超时、返回错误）：**

### 1. 标记状态
```
⚠️ ace-tool unavailable, using fallback strategy
```

### 2. 降级映射表

| ACE Feature | Fallback Command | Notes |
|-------------|------------------|-------|
| Semantic search | `rg "keyword" --type <lang> -C 3` | 多关键字组合搜索 |
| Usage finding | `rg "symbol" --type <lang> -n` | 带行号，便于定位 |
| Context retrieval | `ReadFile` + `rg "import"` | 从入口文件开始 |
| Dependency analysis | `rg "import.*from" --type ts` | 追踪导入关系 |

### 3. 降级后的额外步骤

- 重构操作：必须用 `rg` 二次确认所有用法
- 删除操作：必须搜索所有引用确认无遗漏
- 修改接口：必须查找所有调用方

### 4. 风险标注

降级后的推断需标注：`⚠️ inferred without semantic search, needs confirmation`

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
