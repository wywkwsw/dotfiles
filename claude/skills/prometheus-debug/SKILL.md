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

## Relationship with Core

This skill is the **deep mode** of `prometheus-core` D phase:
- Regular development → Core D phase
- Complex debugging → Core D + Debug skill
