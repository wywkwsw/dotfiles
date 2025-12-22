# Prometheus Skills for Codex

> Modular skill system extending Codex with specialized workflows

## Available Skills

| Skill | Purpose | Triggers |
|-------|---------|----------|
| `prometheus-core` | C.O.D.E workflow | Non-trivial development tasks |
| `prometheus-aether-ui` | Liquid Glass aesthetics | UI, styling, design, frontend |
| `prometheus-debug` | Advanced debugging | bug, error, fix, debug, test failure |
| `prometheus-tooling` | Graceful degradation | Tool unavailable, MCP failure |

## How Skills Work in Codex

1. **Metadata only** at startup: `name` + `description` (~100 words)
2. **Body loads** when skill triggers
3. **References** load on-demand from `references/` subdirectories

## Skill Combinations

| Scenario | Skills Used |
|----------|-------------|
| Feature implementation | `prometheus-core` |
| UI feature | `prometheus-core` + `prometheus-aether-ui` |
| Bug investigation | `prometheus-core` + `prometheus-debug` |
| Tool-limited environment | `prometheus-core` + `prometheus-tooling` |

## Quick Reference

### Core Workflow
```
C → O (⚠️ approval gate) → D → E
```

### Aether UI
```
Radius: rounded-2xl (containers) | rounded-full (pills)
Blur: backdrop-filter / platform equivalent
Motion: ease-out, never linear
```

### Debug Protocol
```
L1: Static review → L2: Unit tests → L3: E2E
Output: Root Cause → Fix → How to Verify
```

