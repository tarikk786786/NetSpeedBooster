# Design System — NetSpeedBooster CLI

## 1. Visual Language & Terminal Style
NetSpeedBooster provides a clean, modern, cyberpunk/terminal aesthetic inspired by GitHub CLI and npm tools. No confusing wall-of-text or raw stack traces.

## 2. Color Palette (ANSI / PowerShell ConsoleColor)
- **Primary / Brand**: `Cyan` (`#00FFFF`) — Headers, banners, feature titles.
- **Success / Passed**: `Green` (`#00FF66`) — Completed optimizations, latency drops, speed improvements.
- **Warning / Notice**: `Yellow` (`#FFFF00`) — Elevation prompts, fallback routes, adapter resets.
- **Error / Critical**: `Red` (`#FF3333`) — Unreachable hosts, missing privileges.
- **Muted / Metadata**: `DarkGray` / `Gray` (`#888888`) — Timestamps, raw ms values, borders.

## 3. UI Component Patterns
- **Header Banner**:
  ```text
  ==============================================================
    NETSPEEDBOOSTER — Windows Network Accelerator & GitHub Hub
  ==============================================================
  ```
- **Status Badges**:
  - `[ OK ]` in Green
  - `[INFO]` in Cyan
  - `[WARN]` in Yellow
  - `[FAIL]` in Red
- **Comparison Table**: Clear before-and-after metrics comparing old vs new latency.
