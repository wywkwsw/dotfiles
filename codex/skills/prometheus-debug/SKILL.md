---
name: prometheus-debug
description: Advanced debugging protocol for root cause analysis and test-driven validation. Use for diagnosing errors, fixing bugs, resolving failing tests, addressing CI issues, investigating crashes, handling exceptions, and fixing regressions. Triggers on keywords like error, bug, debug, failure, exception, crash, CI, test failure, regression, fix.
---

# Advanced Debugging Protocol

## Forbidden Behaviors

- ❌ Commenting out error code to bypass
- ❌ Downgrading dependencies to "fix" conflicts
- ❌ Removing features to avoid errors
- ❌ Ignoring warnings and linter errors

## Required Behaviors

- ✅ Trace the root cause
- ✅ Fix underlying issue, not symptoms
- ✅ Provide verifiable solutions

## Validation Ladder

### L1: Static Review
- Syntax and type checking
- Logic flow analysis
- Edge case verification
- Security vulnerability scan

### L2: Runtime Validation
```bash
pytest tests/              # Python
npm test                   # Node.js
cargo test                 # Rust
go test ./...              # Go
dotnet test                # .NET
```

### L3: End-to-End
- Playwright/Cypress for E2E
- Manual test steps if no automation
- CI/CD pipeline verification

## Debugging Strategies

### Binary Search Isolation
1. Identify working vs failing version
2. Test at midpoint
3. Recursively narrow range

### Log Enhancement
```python
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
logger.debug(f"State: {var}")
```

### Isolation Testing
- Create minimal reproduction
- Remove unrelated dependencies
- Test in clean environment

## Output Format

Every debug response must include:

```markdown
## Root Cause Analysis
<why it broke>

## Fix Solution
<specific changes>

## How to Verify
1. Run: `<command>`
2. Expected: <result>
3. Confirm: <checkpoint>
```

