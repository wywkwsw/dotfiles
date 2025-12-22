# Aether Component Checklist

> All components must follow the "Liquid Glass" design language

## Design Tokens

| Token | Tailwind | CSS Value | WPF/WinUI | SwiftUI |
|-------|----------|-----------|-----------|---------|
| `radius-container` | `rounded-2xl` | `16px` / `1rem` | `CornerRadius="16"` | `.cornerRadius(16)` |
| `radius-pill` | `rounded-full` | `9999px` | `CornerRadius="9999"` | `.clipShape(Capsule())` |
| `blur-backdrop` | `backdrop-blur-xl` | `blur(24px)` | `AcrylicBrush` | `.ultraThinMaterial` |
| `blur-light` | `backdrop-blur-md` | `blur(12px)` | `AcrylicBrush (TintOpacity=0.6)` | `.thinMaterial` |

## Component Radius Rules

### Use `radius-container` (rounded-2xl)
- Accordion, Alert, Autocomplete
- Button, Card, Calendar
- Checkbox, Code, DatePicker
- Dropdown, Drawer, Input
- Listbox, Modal, Popover
- Select, Snippet, Table
- Tabs, Textarea, Tooltip, Toast

### Use `radius-pill` (rounded-full)
- Avatar, Badge, Chip
- Progress bar track
- Slider thumb & track
- Switch track & thumb
- Radio button circles

## Motion Guidelines

| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover | `150ms` | `ease-out` |
| Click/Tap | `100ms` | `ease-in-out` |
| Modal open | `200ms` | `cubic-bezier(0.4, 0, 0.2, 1)` |
| Slide/Drawer | `250ms` | `cubic-bezier(0.4, 0, 0.2, 1)` |
| Page transition | `300ms` | `cubic-bezier(0.4, 0, 0.2, 1)` |

## Platform-Specific Blur APIs

| Platform | API | Notes |
|----------|-----|-------|
| Web | `backdrop-filter: blur()` | Needs `-webkit-` prefix for Safari |
| WPF | `AcrylicBrush` / `MicaBrush` | .NET 6+ recommends WinUI 3 |
| WinUI 3 | `AcrylicBrush`, `MicaBackdrop` | System-level blur effect |
| macOS | `NSVisualEffectView` | `.behindWindow` material |
| SwiftUI | `.background(.ultraThinMaterial)` | iOS 15+ / macOS 12+ |
| Qt | `QGraphicsBlurEffect` + transparent window | Lower performance, use cautiously |
| Tauri | System API passthrough or CSS blur | Depends on webview support |
