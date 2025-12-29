---
name: prometheus-ace
description: Augment Code Engine (ACE) MCP integration for enhanced context understanding and code intelligence. Use when you need deep codebase context, semantic code search, intelligent code completion suggestions, or cross-file relationship analysis. Triggers on complex refactoring, large codebase navigation, and context-heavy development tasks.
---

# Augment Code Engine (ACE) Integration

> ACE 是一个强大的上下文引擎，提供深度代码理解、语义搜索和智能代码分析能力。

## MCP 配置

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

## 核心能力

### 1. 深度上下文理解
- 跨文件依赖分析
- 符号引用追踪
- 调用链路图谱
- 类型推断与传播

### 2. 语义代码搜索
- 自然语言代码搜索
- 相似代码片段发现
- 模式匹配与检测

### 3. 智能代码分析
- 代码质量评估
- 重构建议
- 死代码检测
- 复杂度分析

## 使用场景

| 场景 | ACE 能力 | 触发条件 |
|------|----------|----------|
| 大型重构 | 依赖分析 + 影响范围评估 | 跨模块修改 |
| 新项目理解 | 架构图谱 + 入口点识别 | 项目摸底 |
| Bug 追踪 | 调用链追溯 + 数据流分析 | 复杂 debug |
| 代码迁移 | 相似代码检测 + 模式识别 | 技术栈升级 |

## 与 C.O.D.E 流程集成

### C Phase — 增强上下文构建

在 Contextualize 阶段，优先使用 ACE 构建完整的代码图谱：

```
[STATUS]
Phase: C
Task: <description>
Code-Intel-Sync: ACE context loaded (N files, M symbols)
ACE-Insights:
  - Entry points: <files>
  - Core modules: <modules>
  - External deps: <count>
Next: <action>
```

**ACE 查询策略：**
1. 先获取项目整体结构
2. 识别核心模块和入口点
3. 分析目标代码的依赖关系
4. 追踪相关的类型定义和接口

### O Phase — 影响范围评估

在 Outline 阶段，使用 ACE 评估变更影响：

```
[IMPACT ANALYSIS via ACE]
- Direct changes: <files>
- Affected consumers: <files>
- Test coverage: <percentage>
- Risk level: Low|Medium|High
```

### D Phase — 智能辅助开发

在 Develop 阶段，利用 ACE 提供：
- 相关代码片段参考
- 类型签名建议
- 命名一致性检查
- 导入路径优化

### E Phase — 变更验证

在 Evaluate 阶段，使用 ACE 验证：
- 新代码是否符合项目风格
- 是否引入循环依赖
- 类型安全性检查

## 查询模板

### 1. 项目结构分析
```
分析项目 <path> 的整体架构，识别：
- 入口文件
- 核心模块
- 公共工具
- 外部依赖
```

### 2. 符号追踪
```
追踪符号 <symbol> 的所有引用：
- 定义位置
- 使用位置
- 导出/导入关系
```

### 3. 依赖分析
```
分析文件 <file> 的依赖关系：
- 直接依赖
- 间接依赖
- 被依赖方
```

### 4. 相似代码检测
```
查找与以下代码相似的片段：
<code_snippet>
```

### 5. 重构影响评估
```
评估重构 <description> 的影响：
- 需要修改的文件
- 可能受影响的测试
- 风险等级
```

## 最佳实践

### ✅ 推荐用法
- 在 C 阶段首先使用 ACE 建立全局视图
- 对于复杂重构，先用 ACE 评估影响范围
- 利用语义搜索快速定位相关代码
- 在 code review 时使用 ACE 检查一致性

### ❌ 避免用法
- 简单的单文件修改不需要 ACE
- 已经明确知道修改范围时不必重复查询
- 不要过度依赖 ACE 而忽略人工判断

## 降级策略

当 ACE 不可用时，回退到手动分析：

| ACE 能力 | 降级方案 |
|----------|----------|
| 依赖分析 | `grep -r "import"` + 手动追踪 |
| 符号搜索 | `rg "symbol"` + LSP |
| 相似代码 | 手动模式识别 |
| 架构图谱 | 阅读入口文件 + 目录结构 |

## 响应模板

```
[STATUS]
Phase: <C|O|D|E>
Task: <description>
Code-Intel-Sync: <files read>
ACE-Status: ✅ Connected | ⚠️ Degraded | ❌ Unavailable
ACE-Context: <insights if available>
Next: <action>
```

## 与其他 Skill 组合

| 组合 | 场景 |
|------|------|
| `ace` + `core` | 复杂功能开发 |
| `ace` + `debug` | 深度 bug 追踪 |
| `ace` + `aether-ui` | 大型 UI 重构 |
| `ace` + `tooling` | ACE 降级处理 |
