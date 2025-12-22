---
name: prometheus-aether-ui
description: Aether "Liquid Glass" UI aesthetic rules. Use for UI/UX design, component styling, cross-platform interface development (web, desktop, mobile), frontend beautification, and any task involving visual design, CSS, or component libraries. Triggers on keywords like UI, UX, styling, design, components, frontend, beautify, interface.
---

# Aether Aesthetics (Liquid Glass)

## Core Visual Rules

### 1. Frosted Glass Effect

- Web: `backdrop-filter: blur(24px)`
- See `references/aether-components.md` for platform-specific APIs

### 2. Corner Radius (Only Two Values)

| Type | Tailwind | CSS | Use For |
|------|----------|-----|---------|
| Container | `rounded-2xl` | `16px` | Button, Card, Modal, Input, Dropdown |
| Pill | `rounded-full` | `9999px` | Avatar, Badge, Chip, Switch, Slider |

❌ **FORBIDDEN**: Sharp corners, other radius values

### 3. Motion

| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover | `150ms` | `ease-out` |
| Click | `100ms` | `ease-in-out` |
| Modal/Drawer | `200-250ms` | `cubic-bezier(0.4, 0, 0.2, 1)` |

❌ **FORBIDDEN**: `linear` transitions

## Cross-Platform Mapping

| Platform | Blur API | Corner Radius |
|----------|----------|---------------|
| Web | `backdrop-filter: blur()` | `border-radius` |
| WPF/WinUI | `AcrylicBrush`, `MicaBackdrop` | `CornerRadius` |
| SwiftUI | `.ultraThinMaterial` | `.cornerRadius()` |
| Qt/QML | `FastBlur` | `radius` property |

For complete API details, see `references/aether-components.md`.

## Import Rules

- ✅ Only import components you need
- ❌ Never import entire UI libraries
- ✅ Prefer tree-shakable libraries

