---
name: prometheus-debug
version: 1.0.0
description: Advanced debugging protocol and test-driven validation. Use for diagnosing errors, fixing failing tests, resolving CI issues, addressing regressions.
priority: conditional
triggers: [error, bug, debug, failure, exception, crash, CI, test failure, regression]
---

# Advanced Debugging Protocol

## Core Principles

### ❌ Forbidden Behaviors
- Commenting out error code to bypass issues
- Downgrading dependency versions to "fix" conflicts
- Removing features to avoid errors
- Ignoring warnings and linter errors

### ✅ Required Behaviors
- Trace the root cause
- Fix the underlying issue, not symptoms
- Provide verifiable fix solutions

---

## Validation Ladder

### Level 1: Static Review
- Syntax and type checking
- Logic flow analysis
- Edge case checking
- Security vulnerability scanning

### Level 2: Runtime Validation
- Add or update unit tests
- Add or update integration tests
- Run test suite locally

```bash
# Common command examples
pytest tests/              # Python
npm test                   # Node.js
cargo test                 # Rust
go test ./...              # Go
dotnet test                # .NET
```

### Level 3: End-to-End Validation
- Use Playwright/Cypress for E2E tests
- Manual test steps (if no automation)
- CI/CD pipeline verification

---

## Debugging Strategies

### Binary Search Isolation
1. Identify "working version" and "failing version"
2. Test at midpoint
3. Recursively narrow the range

### Log Enhancement
```python
# Temporary debug logging example
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
logger.debug(f"Variable state: {var}")
```

### Isolation Testing
- Create minimal reproduction case
- Remove unrelated dependencies
- Test in clean environment

### Dependency Analysis
- Check version compatibility
- Review breaking changes
- Verify peer dependencies

---

## Output Format

Every debug response must include:

```markdown
## Root Cause Analysis
<The root cause of the issue>

## Fix Solution
<Specific code changes>

## How to Verify
1. Run: `<command>`
2. Expected result: <description>
3. Confirm: <checkpoint>
```

---

## Tool Priority for Debugging ⚡

调试时的代码上下文获取优先级：

| Priority | Tool | Use For |
|----------|------|---------|
| 1️⃣ | `ace-tool` | 查找错误相关代码、追踪调用链、理解依赖关系 |
| 2️⃣ | `rg` / `grep` | 搜索错误信息、查找特定模式 |
| 3️⃣ | `ReadFile` | 读取错误文件的完整上下文 |

### ace-tool 降级策略

当 ace-tool 不可用时：
1. **标记**：`⚠️ ace-tool unavailable, debug context may be incomplete`
2. **替代**：
   - `rg "error|exception|throw" --type <lang>` 搜索错误模式
   - `rg "function_name" -n` 定位函数定义和调用
   - `git log -p --follow <file>` 追踪文件变更历史
3. **增加验证**：修复后必须运行相关测试确认

---

## Relationship with Core

This skill is the **deep mode** of `prometheus-core` D phase:
- Regular development → Core D phase
- Complex debugging → Core D + Debug skill
