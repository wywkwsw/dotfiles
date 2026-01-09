# Prometheus Skills Index

> Modular skill system with on-demand loading to reduce token consumption

## Skill Inventory


| Skill                    | Purpose                       | Priority       | Auto-Trigger Keywords                            |
| ------------------------ | ----------------------------- | -------------- | ------------------------------------------------ |
| `prometheus-core`        | Core C.O.D.E workflow         | 🔴 Required    | (always active for non-trivial tasks)            |
| `prometheus-aether-ui`   | Liquid Glass UI aesthetics    | 🟡 Conditional | UI, UX, styling, design, component, frontend     |
| `prometheus-debug`       | Advanced debugging protocol   | 🟡 Conditional | bug, error, fix, debug, crash, failing test      |
| `prometheus-tooling`     | Graceful degradation          | 🟢 Fallback    | (auto when tools unavailable)                    |
| `prometheus-ace`         | Augment Code Context Engine   | 🟡 Conditional | context, semantic search, codebase, find usage   |
| `prometheus-ui-inspector`| UI visual inspection          | 🟡 Conditional | UI检查, layout, alignment, overflow, screenshot  |
| `prometheus-performance` | Performance analysis          | 🟡 Conditional | 性能, performance, CWV, LCP, slow, optimization  |
| `prometheus-code-cycle`  | Change header comments        | ⚪ Optional     | audit, tracing, changelog (user request only)    |


---

## Loading Rules

### Priority Order

```
1. prometheus-core          (always loads first)
2. prometheus-ace           (if codebase exploration needed)
3. prometheus-aether-ui     (if UI-related)
4. prometheus-debug         (if debugging-related)
5. prometheus-ui-inspector  (if UI visual inspection needed)
6. prometheus-performance   (if performance analysis needed)
7. prometheus-tooling       (if tools fail)
8. prometheus-code-cycle    (only on explicit request)
```

### Auto-Detection Logic

```
IF task is non-trivial:
    LOAD prometheus-core
    
    IF task.requires(codebase exploration, semantic search, find usage):
        LOAD prometheus-ace
    
    IF task.contains(UI, styling, design, frontend):
        LOAD prometheus-aether-ui
    
    IF task.contains(bug, error, fix, debug, test failure):
        LOAD prometheus-debug
    
    IF task.contains(UI检查, layout check, alignment, overflow, screenshot):
        LOAD prometheus-ui-inspector
    
    IF task.contains(性能, performance, CWV, LCP, slow, optimization):
        LOAD prometheus-performance
    
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


| Scenario               | Skills Loaded                            | Notes                           |
| ---------------------- | ---------------------------------------- | ------------------------------- |
| Simple code change     | `core` only                              | Fast path, may skip O phase     |
| Feature implementation | `core`                                   | Full C.O.D.E loop               |
| UI feature             | `core` + `aether-ui`                     | Apply Liquid Glass aesthetics   |
| Bug investigation      | `core` + `debug`                         | Root cause analysis required    |
| UI bug fix             | `core` + `aether-ui` + `debug`           | Aesthetic + debug protocols     |
| Tool-limited env       | `core` + `tooling`                       | Use fallback strategies         |
| Enterprise project     | `core` + `code-cycle`                    | Add change headers              |
| Full UI project        | `core` + `aether-ui` + `code-cycle`      | Aesthetics + tracing            |
| Codebase exploration   | `core` + `ace`                           | Semantic search + context       |
| Large refactoring      | `core` + `ace` + `debug`                 | Find all usages + validation    |
| UI visual inspection   | `core` + `ui-inspector`                  | Screenshot + DOM analysis       |
| UI QA full check       | `core` + `aether-ui` + `ui-inspector`    | Design + visual verification    |
| Performance analysis   | `core` + `performance`                   | CWV + network + trace analysis  |
| Performance debugging  | `core` + `performance` + `debug`         | Performance + root cause        |
| Full frontend QA       | `core` + `ui-inspector` + `performance`  | Visual + performance testing    |


---

## Conflict Resolution

When skills have conflicting guidance:


| Conflict                         | Resolution                                                   |
| -------------------------------- | ------------------------------------------------------------ |
| `core` vs `debug` on D phase     | `debug` takes precedence for error-related tasks             |
| `aether-ui` vs speed             | Aesthetics are non-negotiable, find efficient implementation |
| `tooling` fallback vs tool usage | Always try tool first, fallback only on failure              |
| `ace-tool` vs `ReadFile`         | **ace-tool 优先**，ReadFile 仅用于读取定位到的文件                         |


---

## Tool Priority Rule ⚡

### ⚠️ ace-tool 自动触发规则（最高优先级）

**当用户请求包含以下任意模式时，必须自动调用 ace-tool：**


| 用户请求                          | 动作                  |
| ----------------------------- | ------------------- |
| "查找..." / "Find..." / "搜索..." | → **自动调用 ace-tool** |
| "...在哪里" / "Where is..."      | → **自动调用 ace-tool** |
| "所有...调用" / "All...calls"     | → **自动调用 ace-tool** |
| "...的用法" / "Usage of..."      | → **自动调用 ace-tool** |
| 任何涉及 API/函数/类/组件 的搜索          | → **自动调用 ace-tool** |


**❌ 禁止等待用户显式说 "用 ace-tool" 才调用！**

### 工具优先级

**代码上下文获取必须遵循以下优先级：**

```
1️⃣ ace-tool (mcp__ace-tool__search_context)  ← 自动触发，MUST TRY FIRST
    ↓ (only if failed)
2️⃣ rg / grep (pattern search)
    ↓ (for specific content)
3️⃣ ReadFile (read located files)
```

**禁止行为：**

- ❌ 跳过 ace-tool 直接用 ReadFile 探索代码
- ❌ 在 ace-tool 可用时使用 grep 进行语义搜索
- ❌ 不尝试 ace-tool 就使用降级方案
- ❌ 等待用户显式提及 "ace-tool" 才调用

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

### ACE (When Exploring) ⚡ PRIORITY TOOL + AUTO-TRIGGER

```
用户说"查找/搜索/找/在哪里/所有..." → 自动调用 ace-tool
无需用户显式提及工具名！

ace-tool FIRST → Fallback to rg/grep → Then ReadFile
MUST try ace-tool before any code exploration
Fallback: rg + ReadFile when ace unavailable
```

### UI Inspector (When Visual QA)

```
Tools: chrome-devtools MCP
  - take_snapshot → DOM 结构快照
  - take_screenshot → 页面/元素截图
  - evaluate_script → 布局分析脚本
  - resize_page → 响应式检查

检查类型:
  🔴 溢出 (overflow)
  🟡 对齐 (alignment)
  🟡 层叠 (z-index)
  🟢 间距 (spacing)

输出: 问题列表 + 截图证据 + 修复建议
```

### Performance (When Optimizing)

```
Tools: chrome-devtools MCP
  - performance_start_trace → 性能追踪
  - performance_stop_trace → 停止追踪
  - performance_analyze_insight → 洞察分析
  - list_network_requests → 网络请求

Core Web Vitals 目标:
  LCP < 2.5s | FCP < 1.8s | CLS < 0.1 | INP < 200ms

输出: CWV 报告 + 资源分析 + 优化建议
```

---

## Version Info


| Skill                   | Version | Last Updated |
| ----------------------- | ------- | ------------ |
| prometheus-core         | 5.1.0   | 2024-12-22   |
| prometheus-aether-ui    | 1.0.0   | 2024-12-22   |
| prometheus-debug        | 1.0.0   | 2024-12-22   |
| prometheus-tooling      | 1.0.0   | 2024-12-22   |
| prometheus-ace          | 1.0.0   | 2024-12-22   |
| prometheus-ui-inspector | 1.0.0   | 2025-01-09   |
| prometheus-performance  | 1.0.0   | 2025-01-09   |
| prometheus-code-cycle   | 1.0.0   | 2024-12-22   |


