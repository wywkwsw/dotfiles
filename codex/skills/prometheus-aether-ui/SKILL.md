---
name: prometheus-aether-ui
version: 1.0.0
description: Aether "Liquid Glass" UI aesthetic rules. Use for UI/UX design, component styling, cross-platform desktop/mobile/web interface development.
priority: conditional
triggers: [UI, UX, styling, components, interface, frontend, beautify, design]
---

# Aether Aesthetics (Liquid Glass Design Language)

## Core Visual Language

### 1. Frosted Glass Effect
- Core feature: Semi-transparent + blurred background
- Web: `backdrop-filter: blur(24px)`
- Desktop/Mobile: Use platform-native APIs (see mapping table below)

### 2. Universal Softness
**Only two corner radius values allowed:**

| Type | Tailwind | CSS | Applicable Components |
|------|----------|-----|----------------------|
| Container | `rounded-2xl` | `16px` | Button, Card, Modal, Input, Dropdown... |
| Pill | `rounded-full` | `9999px` | Avatar, Badge, Chip, Switch, Slider... |

❌ **FORBIDDEN**: Sharp corners or other radius values

### 3. Fluid Motion
| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover | `150ms` | `ease-out` |
| Click | `100ms` | `ease-in-out` |
| Modal/Drawer | `200-250ms` | `cubic-bezier(0.4, 0, 0.2, 1)` |

❌ **FORBIDDEN**: `linear` transitions

---

## Cross-Platform Mapping (Highest Aesthetic Directive)

| Platform | Blur API | Corner Radius API | Animation API |
|----------|----------|-------------------|---------------|
| **Web** | `backdrop-filter: blur()` | `border-radius` | CSS transitions/animations |
| **WPF** | `AcrylicBrush` | `CornerRadius` | `Storyboard` |
| **WinUI 3** | `AcrylicBrush`, `MicaBackdrop` | `CornerRadius` | `AnimationBuilder` |
| **SwiftUI** | `.ultraThinMaterial` | `.cornerRadius()` / `.clipShape()` | `withAnimation(.spring())` |
| **UIKit** | `UIVisualEffectView` | `layer.cornerRadius` | `UIView.animate` |
| **macOS** | `NSVisualEffectView` | `layer.cornerRadius` | `NSAnimationContext` |
| **Qt/QML** | `FastBlur` + transparent window | `radius` property | `Behavior on` / `PropertyAnimation` |
| **Tauri** | System API or CSS blur | CSS `border-radius` | CSS/JS animations |

---

## Component Standard

See `resources/aether-components.md` for:
- Complete Design Token definitions
- 50+ component radius classifications
- Platform-specific API examples

---

## Selective Import Principle

- ✅ Only import components you actually need
- ❌ FORBIDDEN: Import entire UI libraries (e.g., full Material UI)
- ✅ Prefer tree-shakable libraries
