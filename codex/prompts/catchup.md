---
description: 通过读取当前分支上所有未提交的变更（已暂存+未暂存+未跟踪）来继续未完成的工作，然后执行缺失的部分。
argument-hint: [FOCUS="<要完成的事项>"] [MODE=continue|plan|recap]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git ls-files:*), Bash(git rev-parse:*), Read(*), Write(*)
---

## 快照（自动；你无需手动运行任何 VCS 命令）
- 分支 + HEAD: !`git rev-parse --abbrev-ref HEAD && git rev-parse --short HEAD`
- 工作区概要: !`git status -sb`

## 未提交文件清单（必须视为唯一事实来源）
- 已暂存文件: !`git diff --name-only --cached`
- 未暂存文件: !`git diff --name-only`
- 未跟踪文件: !`git ls-files --others --exclude-standard`

---

## ⚡ 第零步：ACE 上下文加载（必须首先执行）

**在分析任何文件之前，必须先调用 `ace-tool` 获取项目上下文！**

### ACE 调用策略

```
调用 ace-tool:
  - query: "分析当前项目结构，识别核心模块、入口文件、未完成的功能（TODO/FIXME/WIP）"
  - project_root_path: <项目根目录绝对路径>
```

### ACE 成功时输出

```
🔍 ACE 上下文加载完成：
- 项目结构：<核心模块>
- 入口文件：<entry files>
- 检测到的 WIP：<count>
```

### 🔄 ACE 降级策略（仅当 ace-tool 不可用时）

| ACE 能力 | 降级方案 |
|----------|----------|
| 项目结构 | `tree -L 2` + 手动阅读入口文件 |
| 符号搜索 | `rg "TODO\|FIXME\|WIP"` |
| 依赖分析 | `grep -r "import"` + 手动追踪 |

降级时输出：`⚠️ ACE 降级模式：<原因>`

---

## 你的任务（MODE=$MODE, FOCUS=$FOCUS）

你正在在上下文丢失后继续工作（简洁/清晰）。不要向用户索要 Git 输出。

### 执行步骤

1) **ACE 上下文加载**（已在第零步完成）

2) **构建"未提交集合"** = 并集(已暂存 + 未暂存 + 未跟踪)。

3) **结合 ACE 上下文分析文件**
   - 利用 ACE 返回的项目结构理解每个文件的角色
   - 从磁盘读取该集合中的**每一个文件**（当前工作树）
   - 如果文件很大/是二进制，做摘要即可，不要整段倾倒

4) **推断未完成的需求**（结合 ACE 洞察）：
   - TODO/FIXME/WIP 标记
   - 半成品函数、缺失的导出、未完成的 UI 流程
   - 失败的测试或缺失测试覆盖率的线索
   - ACE 识别的架构问题或未完成模块

5) **MODE 行为**：
   - `recap`：只总结当前在做什么 + 下一步。
   - `plan`：提出执行计划 + 验证命令。
   - `continue`（默认）：现在就把缺失部分补齐并实现。

6) **在 continue 模式下**：
   - 变更保持最小，并与现有代码风格一致。
   - 如果存在多个合理意图，选择与现有内容最一致的那个并继续，同时说明假设。
   - 利用 ACE 提供的依赖关系确保变更不会破坏其他模块

7) **结束时包含**：
   - 你改了什么（按文件列出）
   - 还剩什么（如果有）
   - 本地需要运行的精确验证步骤
   - ACE 上下文状态（正常/降级）

---

## 输出格式

```
📋 Catchup 分析完成

🔍 上下文：ACE <正常|降级>
📁 未提交文件：N 个
🔧 检测到的 WIP：M 处

### 当前状态
<当前进度摘要>

### 下一步 (MODE=<mode>)
<根据 MODE 的具体行动>
```
