# Prometheus Skills Index

> Modular skill system with on-demand loading to reduce token consumption

## Skill Inventory

| Skill | Purpose | Priority | Auto-Trigger Keywords |
|-------|---------|----------|----------------------|
| `prometheus-core` | Core C.O.D.E workflow | 🔴 Required | (always active for non-trivial tasks) |
| `prometheus-aether-ui` | Liquid Glass UI aesthetics | 🟡 Conditional | UI, UX, styling, design, component, frontend |
| `prometheus-debug` | Advanced debugging protocol | 🟡 Conditional | bug, error, fix, debug, crash, failing test |
| `prometheus-tooling` | Graceful degradation | 🟢 Fallback | (auto when tools unavailable) |
| `prometheus-code-cycle` | Change header comments | ⚪ Optional | audit, tracing, changelog (user request only) |

---

## Loading Rules

### Priority Order
```
1. prometheus-core        (always loads first)
2. prometheus-aether-ui   (if UI-related)
3. prometheus-debug       (if debugging-related)
4. prometheus-tooling     (if tools fail)
5. prometheus-code-cycle  (only on explicit request)
```

### Auto-Detection Logic
```
IF task is non-trivial:
    LOAD prometheus-core
    
    IF task.contains(UI, styling, design, frontend):
        LOAD prometheus-aether-ui
    
    IF task.contains(bug, error, fix, debug, test failure):
        LOAD prometheus-debug
    
    IF MCP_tool.fails OR MCP_tool.unavailable:
        LOAD prometheus-tooling
```

### Manual Override
If a skill doesn't auto-trigger, request:
```
Please use the Prometheus <skill-name> skill for this task
```

---

## Skill Combination Matrix

| Scenario | Skills Loaded | Notes |
|----------|---------------|-------|
| Simple code change | `core` only | Fast path, may skip O phase |
| Feature implementation | `core` | Full C.O.D.E loop |
| UI feature | `core` + `aether-ui` | Apply Liquid Glass aesthetics |
| Bug investigation | `core` + `debug` | Root cause analysis required |
| UI bug fix | `core` + `aether-ui` + `debug` | Aesthetic + debug protocols |
| Tool-limited env | `core` + `tooling` | Use fallback strategies |
| Enterprise project | `core` + `code-cycle` | Add change headers |
| Full UI project | `core` + `aether-ui` + `code-cycle` | Aesthetics + tracing |

---

## Conflict Resolution

When skills have conflicting guidance:

| Conflict | Resolution |
|----------|------------|
| `core` vs `debug` on D phase | `debug` takes precedence for error-related tasks |
| `aether-ui` vs speed | Aesthetics are non-negotiable, find efficient implementation |
| `tooling` fallback vs tool usage | Always try tool first, fallback only on failure |

---

## Quick Reference Cards

### Core (Always)
```
C → O (⚠️ approval gate) → D → E
[STATUS] header required
Context-First: read code, don't guess
```

### Aether UI (When UI)
```
Radius: rounded-2xl (containers) | rounded-full (pills)
Blur: backdrop-filter / platform equivalent
Motion: ease-out/ease-in-out, never linear
```

### Debug (When Fixing)
```
L1: Static review
L2: Unit/integration tests
L3: E2E validation
Output: Root Cause → Fix → How to Verify
```

### Tooling (When Degraded)
```
Tool fails → Check fallback table → Provide alternative
Never block progress due to tool unavailability
```

---

## Version Info

| Skill | Version | Last Updated |
|-------|---------|--------------|
| prometheus-core | 5.1.0 | 2024-12-22 |
| prometheus-aether-ui | 1.0.0 | 2024-12-22 |
| prometheus-debug | 1.0.0 | 2024-12-22 |
| prometheus-tooling | 1.0.0 | 2024-12-22 |
| prometheus-code-cycle | 1.0.0 | 2024-12-22 |
