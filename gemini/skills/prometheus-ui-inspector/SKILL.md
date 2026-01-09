---
name: prometheus-ui-inspector
version: 1.0.0
description: UI visual inspection using Chrome DevTools MCP. Detects layout issues, element misalignment, overflow, and visual regressions through screenshots and DOM analysis.
priority: conditional
triggers:
  # English triggers
  - UI check
  - UI inspect
  - visual check
  - visual inspection
  - layout check
  - layout issue
  - alignment
  - misalignment
  - overflow
  - element offset
  - visual regression
  - responsive check
  - screenshot
  - DOM analysis
  - element position
  - CSS issue
  - style issue
  - z-index
  - overlap
  - spacing
  - margin
  - padding
  
  # Chinese triggers (中文触发词)
  - UI检查
  - 视觉检查
  - 界面检查
  - 布局检查
  - 布局问题
  - 对齐
  - 错位
  - 偏移
  - 溢出
  - 元素偏移
  - 视觉回归
  - 响应式检查
  - 截图
  - DOM分析
  - 元素位置
  - 样式问题
  - 重叠
  - 间距
---

# UI Visual Inspector

## Overview

使用 Chrome DevTools MCP 进行 UI 视觉检查，通过截图分析和 DOM 结构检查来发现布局问题、元素错位、溢出等视觉问题。

---

## Core Capabilities

### 1. 截图分析 (Screenshot Analysis)

通过页面截图进行视觉检查：

```
Tool: mcp__user-chrome-devtools__take_screenshot
Arguments:
{
  "format": "png",
  "fullPage": true  // 全页面截图
}
```

**元素级截图：**
```
Tool: mcp__user-chrome-devtools__take_screenshot
Arguments:
  "uid": "<element_uid>",  // 从 snapshot 获取的元素 uid
  "format": "png"
}
```

### 2. DOM 结构快照 (DOM Snapshot)

获取页面 a11y 树结构用于分析：

```
Tool: mcp__user-chrome-devtools__take_snapshot
Arguments:
{
  "verbose": true  // 获取完整的 a11y 树信息
}
```

### 3. JavaScript 执行分析 (Script Evaluation)

通过执行 JS 脚本获取元素样式和位置信息：

```
Tool: mcp__user-chrome-devtools__evaluate_script
Arguments:
{
  "function": "() => { ... }"  // 分析脚本
}
```

---

## Inspection Workflow

### Phase 1: 准备阶段

1. **导航到目标页面**
```
Tool: mcp__user-chrome-devtools__navigate_page
Arguments:
{
  "type": "url",
  "url": "<target_url>"
}
```

2. **设置视口尺寸**（响应式检查）
```
Tool: mcp__user-chrome-devtools__resize_page
Arguments:
{
  "width": 1920,
  "height": 1080
}
```

### Phase 2: 数据采集

1. **获取 DOM 快照**
```
Tool: mcp__user-chrome-devtools__take_snapshot
Arguments: { "verbose": true }
```

2. **截取全页面截图**
```
Tool: mcp__user-chrome-devtools__take_screenshot
Arguments: { "fullPage": true, "format": "png" }
```

3. **执行布局分析脚本**
```
Tool: mcp__user-chrome-devtools__evaluate_script
Arguments:
{
  "function": "() => {
    const issues = [];
    
    // 检查溢出元素
    document.querySelectorAll('*').forEach(el => {
      const rect = el.getBoundingClientRect();
      const style = getComputedStyle(el);
      
      // 水平溢出检查
      if (el.scrollWidth > el.clientWidth && style.overflowX !== 'scroll') {
        issues.push({
          type: 'horizontal-overflow',
          selector: el.tagName + (el.id ? '#' + el.id : '') + (el.className ? '.' + el.className.split(' ').join('.') : ''),
          scrollWidth: el.scrollWidth,
          clientWidth: el.clientWidth
        });
      }
      
      // 视口外检查
      if (rect.left < 0 || rect.right > window.innerWidth) {
        issues.push({
          type: 'outside-viewport',
          selector: el.tagName + (el.id ? '#' + el.id : ''),
          position: { left: rect.left, right: rect.right }
        });
      }
    });
    
    return issues;
  }"
}
```

### Phase 3: 问题分析

分析采集到的数据，识别以下问题类型：

---

## Issue Detection Categories

### 1. 溢出问题 (Overflow Issues)

| 问题类型 | 检测方法 | 严重程度 |
|---------|---------|---------|
| 水平滚动条 | `scrollWidth > clientWidth` | 🔴 高 |
| 垂直溢出 | `scrollHeight > clientHeight` | 🟡 中 |
| 文本溢出 | `text-overflow: ellipsis` 无效 | 🟡 中 |
| 图片溢出 | `img` 超出容器边界 | 🔴 高 |

**检测脚本：**
```javascript
() => {
  return Array.from(document.querySelectorAll('*')).filter(el => {
    return el.scrollWidth > el.clientWidth || el.scrollHeight > el.clientHeight;
  }).map(el => ({
    element: el.tagName + '#' + el.id,
    overflow: {
      horizontal: el.scrollWidth - el.clientWidth,
      vertical: el.scrollHeight - el.clientHeight
    }
  }));
}
```

### 2. 对齐问题 (Alignment Issues)

| 问题类型 | 检测方法 | 严重程度 |
|---------|---------|---------|
| 元素错位 | 同级元素 `top` 不一致 | 🟡 中 |
| 垂直对齐 | Flexbox 子元素 `alignItems` 异常 | 🟡 中 |
| 间距不一致 | 同类元素 `margin/padding` 差异 | 🟢 低 |

**检测脚本：**
```javascript
() => {
  const flexContainers = document.querySelectorAll('[style*="display: flex"], [style*="display:flex"]');
  const issues = [];
  
  flexContainers.forEach(container => {
    const children = Array.from(container.children);
    const tops = children.map(c => c.getBoundingClientRect().top);
    const uniqueTops = [...new Set(tops)];
    
    if (uniqueTops.length > 1 && getComputedStyle(container).flexDirection === 'row') {
      issues.push({
        type: 'flex-alignment',
        container: container.className,
        childTops: tops
      });
    }
  });
  
  return issues;
}
```

### 3. 层叠问题 (Z-Index Issues)

| 问题类型 | 检测方法 | 严重程度 |
|---------|---------|---------|
| 元素被遮挡 | 重要元素 `z-index` 过低 | 🔴 高 |
| Modal 穿透 | 弹窗层级不正确 | 🔴 高 |
| 下拉菜单被遮挡 | Dropdown `z-index` 问题 | 🟡 中 |

### 4. 响应式问题 (Responsive Issues)

需要在多个视口尺寸下检查：

**常用断点：**

| 设备 | 宽度 | 高度 |
|-----|------|------|
| Mobile S | 320 | 568 |
| Mobile M | 375 | 667 |
| Mobile L | 425 | 812 |
| Tablet | 768 | 1024 |
| Laptop | 1024 | 768 |
| Desktop | 1440 | 900 |
| 4K | 2560 | 1440 |

**响应式检查流程：**
```
1. resize_page → 设置视口
2. take_screenshot → 截图
3. evaluate_script → 检查溢出
4. 重复以上步骤，覆盖所有断点
```

---

## Analysis Scripts Library

### 获取所有元素位置信息

```javascript
() => {
  return Array.from(document.querySelectorAll('*')).slice(0, 100).map(el => {
    const rect = el.getBoundingClientRect();
    const style = getComputedStyle(el);
    return {
      tag: el.tagName,
      id: el.id,
      class: el.className,
      rect: { top: rect.top, left: rect.left, width: rect.width, height: rect.height },
      display: style.display,
      position: style.position,
      zIndex: style.zIndex
    };
  });
}
```

### 检查固定定位元素

```javascript
() => {
  return Array.from(document.querySelectorAll('*')).filter(el => {
    const style = getComputedStyle(el);
    return style.position === 'fixed' || style.position === 'sticky';
  }).map(el => ({
    tag: el.tagName,
    id: el.id,
    position: getComputedStyle(el).position,
    zIndex: getComputedStyle(el).zIndex,
    rect: el.getBoundingClientRect()
  }));
}
```

### 检查可访问性问题

```javascript
() => {
  const issues = [];
  
  // 检查图片 alt
  document.querySelectorAll('img:not([alt])').forEach(img => {
    issues.push({ type: 'missing-alt', src: img.src });
  });
  
  // 检查按钮文本
  document.querySelectorAll('button:empty').forEach(btn => {
    issues.push({ type: 'empty-button', html: btn.outerHTML.slice(0, 100) });
  });
  
  // 检查对比度（简化版）
  document.querySelectorAll('*').forEach(el => {
    const style = getComputedStyle(el);
    if (style.fontSize && parseFloat(style.fontSize) < 12) {
      issues.push({ type: 'small-text', size: style.fontSize, text: el.textContent?.slice(0, 50) });
    }
  });
  
  return issues;
}
```

---

## Output Format

每次 UI 检查必须输出：

```markdown
## UI 检查报告

### 检查范围
- **页面**: <URL>
- **视口**: <width> x <height>
- **检查时间**: <timestamp>

### 发现的问题

#### 🔴 严重问题 (Critical)
| # | 问题类型 | 元素 | 描述 | 建议修复 |
|---|---------|------|------|---------|
| 1 | 水平溢出 | `.container` | 内容超出 200px | 添加 `overflow-x: hidden` 或调整内容宽度 |

#### 🟡 中等问题 (Medium)
| # | 问题类型 | 元素 | 描述 | 建议修复 |
|---|---------|------|------|---------|
| 1 | 对齐偏差 | `.card-list` | 卡片垂直对齐不一致 | 检查 `align-items` 设置 |

#### 🟢 轻微问题 (Minor)
| # | 问题类型 | 元素 | 描述 | 建议修复 |
|---|---------|------|------|---------|
| 1 | 间距不一致 | `.btn` | 按钮间距 8px/12px 混用 | 统一使用设计规范间距 |

### 截图证据
<附上相关截图>

### 验证方式
1. 修复后重新运行检查
2. 对比前后截图
3. 确认问题已解决
```

---

## Integration with Prometheus Workflow

### 在 C 阶段使用

```
1. 获取页面 DOM 快照，理解页面结构
2. 截图分析当前视觉状态
3. 识别可能的问题区域
```

### 在 E 阶段使用

```
1. 修改后重新截图对比
2. 运行溢出/对齐检查脚本
3. 验证问题已修复
```

---

## Best Practices

### Do ✅

- 先 `take_snapshot` 获取 DOM 结构，再针对性截图
- 多个断点下进行响应式检查
- 保存截图作为回归测试基准
- 使用 `evaluate_script` 获取精确的数值数据

### Don't ❌

- 仅凭单一视口判断整体布局
- 忽略移动端适配检查
- 不保存截图证据
- 仅依赖目视检查，不使用脚本验证

---

## Fallback Strategy

当 chrome-devtools MCP 不可用时：

1. **标记状态**
```
⚠️ chrome-devtools unavailable, manual inspection required
```

2. **替代方案**
   - 使用浏览器开发者工具手动检查
   - 提供检查清单供人工执行
   - 使用 Playwright MCP 作为备选

3. **手动检查清单**
```markdown
- [ ] 在 1920x1080 下检查页面布局
- [ ] 在 375x667 (Mobile) 下检查响应式
- [ ] 检查水平滚动条是否出现
- [ ] 检查元素是否超出视口
- [ ] 检查弹窗/下拉菜单层级
```

---

## Relationship with Other Skills

| Skill | 关联 |
|-------|------|
| `prometheus-aether-ui` | UI 设计规范，检查是否符合设计系统 |
| `prometheus-debug` | 布局问题定位后的修复流程 |
| `prometheus-performance` | 视觉问题可能影响性能（如大图、重绘） |
