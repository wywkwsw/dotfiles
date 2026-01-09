---
name: prometheus-ace
version: 1.1.0
description: Augment Code Context Engine (ACE) MCP integration. MUST USE ace-tool for ANY code search, finding, or exploration task. ace-tool is the PRIMARY and DEFAULT tool for understanding code.
priority: high
triggers:
  # English triggers
  - find
  - search
  - locate
  - where
  - how
  - what
  - which
  - show me
  - list all
  - get all
  - all usages
  - all references
  - all calls
  - all implementations
  - usage
  - reference
  - call
  - implementation
  - definition
  - declaration
  - import
  - export
  - depend
  - relationship
  - context
  - codebase
  - semantic
  - understand
  - explore
  - analyze
  # Chinese triggers (中文触发词)
  - 查找
  - 搜索
  - 查询
  - 定位
  - 找到
  - 找出
  - 列出
  - 获取
  - 显示
  - 在哪
  - 哪里
  - 如何
  - 怎么
  - 什么
  - 哪些
  - 所有
  - 全部
  - 调用
  - 引用
  - 使用
  - 实现
  - 定义
  - 声明
  - 导入
  - 导出
  - 依赖
  - 关系
  - 上下文
  - 代码库
  - 分析
  - 理解
  # Pattern triggers
  - API
  - function
  - class
  - method
  - component
  - module
  - service
  - handler
  - controller
  - hook
  - util
  - helper
  - 函数
  - 类
  - 方法
  - 组件
  - 模块
  - 服务
  - 接口
---

# Augment Code Context Engine (ACE)

## ⚠️ CRITICAL: Auto-Activation Rule

**ace-tool MUST be automatically invoked for ANY of the following user intents:**

| User Intent Pattern | Action |
|---------------------|--------|
| "查找..." / "Find..." | → Use ace-tool |
| "搜索..." / "Search..." | → Use ace-tool |
| "...在哪里" / "Where is..." | → Use ace-tool |
| "所有...调用" / "All...calls" | → Use ace-tool |
| "...的用法" / "Usage of..." | → Use ace-tool |
| "如何实现..." / "How is...implemented" | → Use ace-tool |
| "哪些...使用了..." / "What uses..." | → Use ace-tool |
| Any code exploration task | → Use ace-tool FIRST |

**DO NOT wait for user to explicitly mention "ace-tool"!**

---

## Overview

ACE is a powerful context engine that provides semantic understanding of your codebase. **It is the PRIMARY and DEFAULT tool** for intelligent code search, usage finding, and context retrieval.

---

## When to Use ACE (Default: YES)

| Scenario | Use ACE | Alternative |
|----------|---------|-------------|
| **Any code search request** | ✅ **YES (default)** | - |
| "查找所有 API 调用" | ✅ **YES** | - |
| "Find all usages of X" | ✅ **YES** | - |
| Semantic code search | ✅ **YES** | - |
| Find all usages of a function/class | ✅ **YES** | `rg` only as fallback |
| Understand code relationships | ✅ **YES** | - |
| Cross-file context gathering | ✅ **YES** | Manual file reading |
| **Only** simple exact text match | ❌ | Use `rg` or `Grep` |
| **Only** single known file reading | ❌ | Use `ReadFile` |

**Rule: When in doubt, USE ace-tool!**

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
