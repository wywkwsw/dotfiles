---
name: prometheus-ace
version: 1.0.0
description: Code Context Engine integration. Use for codebase-wide semantic search, context retrieval, and intelligent code understanding.
priority: conditional
triggers: [context, codebase search, semantic search, find usage, code understanding]
---

# Code Context Engine (ACE)

## Overview

ACE provides semantic understanding of your codebase. Use it for intelligent code search, usage finding, and context retrieval beyond simple grep.

---

## When to Use Semantic Search

| Scenario | Use Semantic Search | Alternative |
|----------|---------------------|-------------|
| Semantic code search | ✅ | - |
| Find all usages of a function/class | ✅ | `rg` for simple cases |
| Understand code relationships | ✅ | - |
| Cross-file context gathering | ✅ | Manual file reading |
| Simple text/pattern search | ❌ | Use `rg` or `grep` |
| Single file reading | ❌ | Use Read File |

---

## Capabilities

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
1. Use semantic search for broad codebase understanding
2. Identify relevant files and relationships
3. Build comprehensive Code-Intel-Map
```

### O Phase (Outline)
```
1. Use semantic search to find existing patterns
2. Check for similar implementations
3. Identify files that need modification
```

### D Phase (Develop)
```
1. Use semantic search to find all usages before refactoring
2. Verify no missing references
3. Check for breaking changes
```

---

## Usage Priority ⚡ (MUST FOLLOW)

**语义搜索是代码上下文获取的首选工具。**

| Priority | Tool | Use For | Fallback Trigger |
|----------|------|---------|------------------|
| 1️⃣ | Semantic Search | 语义搜索、代码关系、广泛理解 | 连接失败/超时/错误 |
| 2️⃣ | `rg` / `grep` | 精确模式匹配、符号定位 | 语义搜索不可用时 |
| 3️⃣ | Read File | 读取具体文件内容 | 作为补充手段 |

### 强制规则

- ✅ **每次需要理解代码时，必须先尝试语义搜索**
- ✅ 仅当语义搜索失败后才使用 rg/grep 降级
- ✅ ReadFile 用于读取语义搜索定位到的具体文件
- ❌ 禁止跳过语义搜索直接使用 ReadFile 进行探索

---

## Best Practices

### Do ✅
- Use semantic search early in C phase for codebase exploration
- Combine search results with targeted file reads
- Use semantic search to verify refactoring completeness

### Don't ❌
- Use semantic search for simple keyword searches (use `rg`)
- Over-rely on semantic search when files are already known
- Skip search results review before making changes

---

## Fallback Strategy ⚠️

**当语义搜索不可用时（连接失败、超时、返回错误）：**

### 1. 标记状态
```
⚠️ semantic search unavailable, using fallback strategy
```

### 2. 降级映射表

| Feature | Fallback Command | Notes |
|---------|------------------|-------|
| Semantic search | `rg "keyword" --type <lang> -C 3` | 多关键字组合搜索 |
| Usage finding | `rg "symbol" --type <lang> -n` | 带行号，便于定位 |
| Context retrieval | Read File + `rg "import"` | 从入口文件开始 |
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
