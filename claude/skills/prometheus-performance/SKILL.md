---
name: prometheus-performance
version: 1.0.0
description: Comprehensive performance analysis using Chrome DevTools MCP. Includes Core Web Vitals measurement, performance tracing, network analysis, and optimization recommendations.
priority: conditional
triggers:
  # English triggers
  - performance
  - performance check
  - performance analysis
  - performance optimization
  - slow
  - loading time
  - page speed
  - Core Web Vitals
  - CWV
  - LCP
  - FCP
  - CLS
  - FID
  - INP
  - TTFB
  - network analysis
  - request analysis
  - bundle size
  - memory leak
  - CPU usage
  - rendering
  - paint
  - trace
  - profiling
  
  # Chinese triggers (中文触发词)
  - 性能
  - 性能检查
  - 性能分析
  - 性能优化
  - 加载慢
  - 加载时间
  - 页面速度
  - 网络分析
  - 请求分析
  - 包体积
  - 内存泄漏
  - CPU占用
  - 渲染
  - 绘制
  - 追踪
  - 性能剖析
  - 首屏
  - 白屏
---

# Performance Analysis

## Overview

使用 Chrome DevTools MCP 进行全面的性能分析，包括 Core Web Vitals 测量、性能追踪、网络请求分析，以及针对性的优化建议。

---

## Core Capabilities

### 1. 性能追踪 (Performance Tracing)

启动性能追踪记录：

```
Tool: mcp__user-chrome-devtools__performance_start_trace
Arguments:
{
  "reload": true,    // 开始追踪后自动重新加载页面
  "autoStop": true   // 自动停止追踪
}
```

停止追踪（如未自动停止）：

```
Tool: mcp__user-chrome-devtools__performance_stop_trace
```

### 2. 性能洞察分析 (Performance Insights)

获取特定性能洞察的详细信息：

```
Tool: mcp__user-chrome-devtools__performance_analyze_insight
Arguments:
{
  "insightSetId": "<insight_set_id>",  // 从追踪结果获取
  "insightName": "LCPBreakdown"        // 洞察类型
}
```

**常用洞察类型：**

| 洞察名称 | 说明 |
|---------|------|
| `LCPBreakdown` | LCP 详细分解分析 |
| `DocumentLatency` | 文档加载延迟分析 |
| `RenderBlocking` | 渲染阻塞资源分析 |
| `LongTasks` | 长任务分析 |
| `NetworkRequests` | 网络请求分析 |

### 3. 网络请求分析 (Network Analysis)

获取所有网络请求：

```
Tool: mcp__user-chrome-devtools__list_network_requests
Arguments:
{
  "resourceTypes": ["script", "stylesheet", "fetch", "xhr"],
  "pageSize": 50
}
```

**资源类型过滤：**

| 类型 | 说明 |
|-----|------|
| `document` | HTML 文档 |
| `script` | JavaScript 文件 |
| `stylesheet` | CSS 文件 |
| `image` | 图片资源 |
| `font` | 字体文件 |
| `fetch` / `xhr` | API 请求 |
| `media` | 音视频资源 |

### 4. 控制台消息分析 (Console Messages)

获取控制台警告和错误：

```
Tool: mcp__user-chrome-devtools__list_console_messages
```

---

## Performance Analysis Workflow

### Phase 1: 准备阶段

1. **导航到目标页面**
```
Tool: mcp__user-chrome-devtools__navigate_page
Arguments:
{
  "type": "url",
  "url": "<target_url>",
  "timeout": 30000
}
```

2. **清除缓存（可选，测试首次加载）**
```
Tool: mcp__user-chrome-devtools__navigate_page
Arguments:
{
  "type": "reload",
  "ignoreCache": true
}
```

### Phase 2: 性能数据采集

1. **启动性能追踪**
```
Tool: mcp__user-chrome-devtools__performance_start_trace
Arguments:
{
  "reload": true,
  "autoStop": true
}
```

2. **获取网络请求列表**
```
Tool: mcp__user-chrome-devtools__list_network_requests
Arguments: {}
```

3. **获取控制台消息**
```
Tool: mcp__user-chrome-devtools__list_console_messages
```

### Phase 3: 深度分析

根据追踪结果，获取详细洞察：

```
Tool: mcp__user-chrome-devtools__performance_analyze_insight
Arguments:
{
  "insightSetId": "<from_trace_result>",
  "insightName": "LCPBreakdown"
}
```

### Phase 4: 优化建议

基于分析结果生成优化建议。

---

## Core Web Vitals Analysis

### LCP (Largest Contentful Paint) - 最大内容渲染

**目标**: < 2.5s (Good), < 4s (Needs Improvement), > 4s (Poor)

| 问题原因 | 检测方法 | 优化建议 |
|---------|---------|---------|
| 大图片未优化 | 检查 image 请求大小 | 使用 WebP/AVIF, lazy loading |
| 服务器响应慢 | 检查 TTFB | CDN, 服务端缓存 |
| 渲染阻塞资源 | RenderBlocking 洞察 | async/defer, 关键 CSS 内联 |
| 客户端渲染延迟 | LCPBreakdown 洞察 | SSR/SSG, 预渲染 |

**分析命令：**
```
Tool: mcp__user-chrome-devtools__performance_analyze_insight
Arguments:
{
  "insightSetId": "<id>",
  "insightName": "LCPBreakdown"
}
```

### FCP (First Contentful Paint) - 首次内容渲染

**目标**: < 1.8s (Good), < 3s (Needs Improvement), > 3s (Poor)

| 问题原因 | 检测方法 | 优化建议 |
|---------|---------|---------|
| 阻塞性 JS | 检查 script 加载顺序 | defer/async |
| 大型 CSS | 检查 stylesheet 大小 | Critical CSS, 代码分割 |
| 字体加载 | 检查 font 请求 | font-display: swap |

### CLS (Cumulative Layout Shift) - 累积布局偏移

**目标**: < 0.1 (Good), < 0.25 (Needs Improvement), > 0.25 (Poor)

| 问题原因 | 检测方法 | 优化建议 |
|---------|---------|---------|
| 图片无尺寸 | DOM 快照检查 img 属性 | 设置 width/height |
| 动态内容插入 | 性能追踪检查 | 预留空间 |
| 字体闪烁 | 字体加载分析 | font-display: optional |
| 广告/iframe | 检查动态元素 | 预留容器尺寸 |

### INP (Interaction to Next Paint) - 交互到下一帧渲染

**目标**: < 200ms (Good), < 500ms (Needs Improvement), > 500ms (Poor)

| 问题原因 | 检测方法 | 优化建议 |
|---------|---------|---------|
| 长任务阻塞 | LongTasks 洞察 | 任务分片, Web Worker |
| 主线程繁忙 | 性能追踪分析 | 减少同步操作 |
| 大量 DOM 操作 | 脚本分析 | 虚拟列表, DOM 批量更新 |

---

## Network Performance Analysis

### 请求分析检查清单

```markdown
### 网络请求分析

| 指标 | 当前值 | 目标值 | 状态 |
|-----|-------|-------|-----|
| 总请求数 | <n> | < 50 | ✅/❌ |
| 总传输大小 | <n> KB | < 1MB | ✅/❌ |
| JS 总大小 | <n> KB | < 300KB | ✅/❌ |
| CSS 总大小 | <n> KB | < 100KB | ✅/❌ |
| 图片总大小 | <n> KB | < 500KB | ✅/❌ |
| 最慢请求 | <n> ms | < 1000ms | ✅/❌ |
```

### 资源优化分析脚本

```
Tool: mcp__user-chrome-devtools__evaluate_script
Arguments:
{
  "function": "() => {
    const resources = performance.getEntriesByType('resource');
    return {
      total: resources.length,
      byType: resources.reduce((acc, r) => {
        const type = r.initiatorType;
        acc[type] = acc[type] || { count: 0, totalSize: 0, totalDuration: 0 };
        acc[type].count++;
        acc[type].totalDuration += r.duration;
        return acc;
      }, {}),
      slowest: resources.sort((a, b) => b.duration - a.duration).slice(0, 5).map(r => ({
        name: r.name.split('/').pop(),
        duration: Math.round(r.duration),
        type: r.initiatorType
      }))
    };
  }"
}
```

---

## Memory Analysis

### 内存使用检查

```
Tool: mcp__user-chrome-devtools__evaluate_script
Arguments:
{
  "function": "() => {
    if (performance.memory) {
      return {
        usedJSHeapSize: Math.round(performance.memory.usedJSHeapSize / 1024 / 1024) + ' MB',
        totalJSHeapSize: Math.round(performance.memory.totalJSHeapSize / 1024 / 1024) + ' MB',
        jsHeapSizeLimit: Math.round(performance.memory.jsHeapSizeLimit / 1024 / 1024) + ' MB'
      };
    }
    return { error: 'Memory API not available' };
  }"
}
```

### 内存泄漏检测模式

1. **基准测量**：页面加载后记录初始内存
2. **操作触发**：执行可能导致泄漏的操作（导航、打开模态框等）
3. **对比测量**：操作完成后再次测量
4. **分析差异**：内存持续增长表示可能存在泄漏

---

## Rendering Performance

### 帧率分析

```
Tool: mcp__user-chrome-devtools__evaluate_script
Arguments:
{
  "function": "() => {
    return new Promise(resolve => {
      let frames = 0;
      let startTime = performance.now();
      
      function countFrame() {
        frames++;
        if (performance.now() - startTime < 1000) {
          requestAnimationFrame(countFrame);
        } else {
          resolve({ fps: frames, duration: performance.now() - startTime });
        }
      }
      
      requestAnimationFrame(countFrame);
    });
  }"
}
```

### 重绘/重排检测

关注以下 CSS 属性变化（会触发重排）：

| 属性类型 | 属性 | 影响 |
|---------|------|------|
| 几何属性 | width, height, padding, margin | 触发重排 |
| 位置属性 | top, left, position | 触发重排 |
| 显示属性 | display, visibility | 触发重排/重绘 |
| 安全属性 | transform, opacity | 仅合成层，性能好 |

---

## Output Format

每次性能检查必须输出：

```markdown
## 性能分析报告

### 基本信息
- **页面**: <URL>
- **检查时间**: <timestamp>
- **网络条件**: <network_type>

### Core Web Vitals

| 指标 | 当前值 | 目标值 | 状态 | 优先级 |
|-----|-------|-------|-----|-------|
| LCP | <n>s | < 2.5s | 🔴/🟡/🟢 | P0 |
| FCP | <n>s | < 1.8s | 🔴/🟡/🟢 | P1 |
| CLS | <n> | < 0.1 | 🔴/🟡/🟢 | P1 |
| INP | <n>ms | < 200ms | 🔴/🟡/🟢 | P0 |
| TTFB | <n>ms | < 800ms | 🔴/🟡/🟢 | P1 |

### 资源加载分析

| 资源类型 | 数量 | 总大小 | 平均耗时 |
|---------|------|-------|---------|
| JavaScript | <n> | <n>KB | <n>ms |
| CSS | <n> | <n>KB | <n>ms |
| Images | <n> | <n>KB | <n>ms |
| Fonts | <n> | <n>KB | <n>ms |
| API Calls | <n> | <n>KB | <n>ms |

### 问题列表

#### 🔴 严重问题 (Critical)
| # | 问题 | 影响 | 优化建议 |
|---|-----|------|---------|
| 1 | LCP 元素为未优化图片 | +2s 加载时间 | 使用 WebP, 设置 srcset |

#### 🟡 中等问题 (Medium)
| # | 问题 | 影响 | 优化建议 |
|---|-----|------|---------|
| 1 | 未压缩的 JS bundle | +500KB 传输 | 启用 gzip/brotli |

#### 🟢 优化建议 (Suggestions)
| # | 建议 | 预期收益 |
|---|-----|---------|
| 1 | 启用 HTTP/2 | 并行请求加速 |

### 验证方式
1. 运行 Lighthouse 对比分数
2. 使用 WebPageTest 进行多次测量
3. 监控 RUM 数据变化
```

---

## Optimization Strategies

### Quick Wins (立即生效)

| 策略 | 实现 | 预期收益 |
|-----|------|---------|
| 启用压缩 | gzip/brotli | 减少 60-80% 传输 |
| 图片优化 | WebP + 压缩 | 减少 30-50% 图片大小 |
| 缓存策略 | Cache-Control headers | 减少重复请求 |
| 预连接 | `<link rel="preconnect">` | 减少 DNS/TCP 延迟 |

### Medium Effort (需要开发)

| 策略 | 实现 | 预期收益 |
|-----|------|---------|
| 代码分割 | Dynamic imports | 减少初始 bundle |
| 懒加载 | Intersection Observer | 延迟非关键资源 |
| 关键 CSS | Critical CSS 内联 | 加速首屏渲染 |
| Service Worker | PWA 缓存 | 离线可用 + 加速 |

### Long Term (架构优化)

| 策略 | 实现 | 预期收益 |
|-----|------|---------|
| SSR/SSG | Next.js, Nuxt | 加速 FCP/LCP |
| Edge Computing | CDN Workers | 减少 TTFB |
| 微前端 | Module Federation | 按需加载模块 |

---

## Integration with Prometheus Workflow

### 在 C 阶段使用

```
1. 性能追踪，获取当前基线数据
2. 识别主要性能瓶颈
3. 确定优化优先级
```

### 在 D 阶段使用

```
1. 每次修改后重新测量
2. 对比性能变化
3. 确保不引入性能回归
```

### 在 E 阶段使用

```
1. 完整性能测试
2. 对比优化前后数据
3. 生成性能报告
```

---

## Best Practices

### Do ✅

- 多次测量取平均值，避免网络波动影响
- 同时测试有缓存和无缓存场景
- 关注真实用户数据 (RUM)，不仅是实验室数据
- 按优先级逐个优化，每次验证效果

### Don't ❌

- 仅依赖单次测量结果
- 忽略移动端网络条件测试
- 过度优化不重要的指标
- 优化前不建立基线

---

## Fallback Strategy

当 chrome-devtools MCP 不可用时：

1. **标记状态**
```
⚠️ chrome-devtools unavailable, using alternative tools
```

2. **替代方案**

| 原工具 | 替代方案 |
|-------|---------|
| performance_start_trace | Lighthouse CLI |
| list_network_requests | 浏览器 Network 面板手动检查 |
| evaluate_script | 浏览器控制台手动执行 |

3. **Lighthouse CLI 命令**
```bash
npx lighthouse <url> --output=json --output-path=./report.json
```

4. **WebPageTest 在线测试**
```
https://www.webpagetest.org/
```

---

## Relationship with Other Skills

| Skill | 关联 |
|-------|------|
| `prometheus-ui-inspector` | 性能问题可能由 UI 问题（大图、复杂 DOM）导致 |
| `prometheus-debug` | 性能问题定位后的修复流程 |
| `prometheus-core` | 在 D 阶段集成性能验证 |
