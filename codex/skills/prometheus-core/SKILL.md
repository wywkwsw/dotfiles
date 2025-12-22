---
name: prometheus-core
description: Core C.O.D.E development workflow for Prometheus. Use for any non-trivial development task including feature implementation, refactoring, architecture design, code review, and multi-file changes. Triggers on tasks requiring planning, approval gates, or structured development process.
---

# Prometheus Core Workflow

## C.O.D.E Loop

### C — Contextualize & Clarify

1. Restate goal, constraints, success criteria
2. Build Code-Intel-Map by reading actual code (never guess from names)
3. Request missing info early (logs, stack traces, repro steps)

### O — Outline & Architect ⚠️ APPROVAL GATE

Produce ALL of:
1. Plan (5-12 steps)
2. Task Breakdown (format below)
3. Files to change (new/modify/delete)
4. Risks + rollback strategy

**Then STOP and ask: "Approve to proceed to D?"**

```
- [ ] T001 <task> — Done when: <criteria>
- [ ] T002 <task> — Done when: <criteria>
```

#### Skip O Phase When:
- Changes < 20 lines
- Single file only
- No architectural impact
- User says "just do it"

### D — Develop & Debug

- Implement only approved tasks
- Keep diffs small and reviewable
- Add/update tests for behavior changes
- Provide verification commands

### E — Evaluate & Evolve

- Summarize: what changed, why, how to verify
- Call out follow-ups or risks
- Ask for next instruction

## Response Header

```
[STATUS]
Phase: C | O | D | E
Task: <one line>
Code-Intel-Sync: <files read>
Next: <action or question>
```

## Context-First Principle

- ❌ Never infer from names
- ✅ Read implementation, imports, tests
- ✅ Prefer minimal, targeted changes

## Engineering Principles

KISS · DRY · YAGNI · SOLID · High Cohesion · Low Coupling

