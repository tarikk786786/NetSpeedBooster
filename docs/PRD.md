# Product Requirements Document — NetSpeedBooster

## 1. Product Overview
Product Name: NetSpeedBooster
One-Line Description: An automated Windows network optimization, diagnostic, and speed acceleration suite leveraging verified open-source GitHub tools and deep Windows network stack tuning.
Product Type: CLI & PowerShell Automation Suite
Primary Platform: Windows 10 / Windows 11 (Desktop)

## 2. Problem
What problem are we solving? Users encounter severe internet latency, sluggish browsing, bufferbloat, and artificial link speed throttling caused by:
1. Sluggish default ISP/router DNS resolution (often 300ms-600ms per lookup).
2. Misconfigured Wi-Fi adapter drivers (e.g., Intel AX211 sticking to congested 2.4 GHz 802.11n bands with Throughput Booster and MIMO Power Save unoptimized).
3. Stale Windows network caches, cluttered ARP tables, and unoptimized TCP parameters.
4. Windows Update Delivery Optimization consuming background bandwidth without user awareness.

Why does this problem matter? Network latency and throttled bandwidth directly degrade productivity, streaming quality, developer workflows, and web browsing speeds.
How are users solving this today? Manually hunting across fragmented registry tweaks, obscure `netsh` commands, or sketchy third-party "PC cleaner" malware.

## 3. Goal
Primary Goal: Provide an open-source, safe, transparent 1-click optimization that cuts DNS lookup latency by >70% and maximizes Wi-Fi adapter throughput with automatic backup and rollback.
Secondary Goals:
- Integrate vetted GitHub open-source tools (ChrisTitusTech WinUtil, CleanBrowsing DNS benchmark, GoodbyeDPI).
- Auto-detect hardware (like Intel Wi-Fi 6E AX211) and apply hardware-specific throughput flags.
- Create automated diagnostic benchmarks before and after optimization.

## 4. Target Users
### Windows Power User & Developer
Name: Tarik / Developer
Description: Active developer working on high-bandwidth tasks requiring low-latency internet and fast DNS queries.
Needs:
- Instant website loading and low ping.
- Clear transparency on what system settings are changed.
- Zero malware, zero telemetry, purely open-source.
Pain Points:
- Router DNS adding 400ms+ latency to every new domain.
- Adapter locked to 2.4 GHz 72.2 Mbps rate despite having a Wi-Fi 6E card.

## 5. User Stories
- As a user, I want to run a 1-click script that optimizes my DNS to Cloudflare/Quad9 so that browsing feels instantaneous.
- As a user, I want my Intel Wi-Fi adapter tuned to prefer 5GHz and enable throughput bursting so that my local connection speed is maximized.
- As a user, I want a backup snapshot of my previous settings so that I can revert at any time with complete peace of mind.
- As a user, I want direct integration with trusted GitHub utilities like WinUtil for deeper Windows OS debloating.

## 6. Core Features
### Feature 1 — Automated DNS Benchmarking & Switching
Purpose: Benchmark local router vs Cloudflare (1.1.1.1), Quad9 (9.9.9.9), Google (8.8.8.8) and apply the fastest resolver.
User Flow: Script measures ping and query time, backs up existing DNS, and sets the lowest-latency DNS server.
Inputs: Network interface alias (Wi-Fi/Ethernet).
Outputs: Pre- and post-optimization query latency in milliseconds.
Acceptance Criteria:
- Must test at least 4 reputable public resolvers.
- Must persist settings across reboots.

### Feature 2 — Intel Wi-Fi 6E & Hardware Throughput Tuning
Purpose: Optimize advanced adapter properties on Intel AX211/AX200/AX210 and standard Wi-Fi cards.
User Flow: Sets Preferred Band to 5GHz, Throughput Booster to Enabled, and MIMO Power Save to No SMPS.
Acceptance Criteria:
- Modifies properties safely via CIM/WMI without breaking driver bindings.

### Feature 3 — TCP & Network Stack Refresh
Purpose: Flush DNS resolver cache, refresh ARP tables, and optimize TCP autotuning.
Acceptance Criteria:
- Reclaims stuck sockets, flushes bad DNS entries.

### Feature 4 — GitHub Tools Integration Hub
Purpose: Provide direct shortcuts to launch Chris Titus WinUtil, GoodbyeDPI, and Speedtest CLI.

## 7. Non-Goals
- Modifying router firmware (must work entirely on the client PC side).
- Using paid VPNs or proprietary closed-source utilities.

## 8. Success Metrics
- Average DNS resolution latency reduced by at least 60% (from ~450ms down to <70ms).
- Successful backup snapshot created in `data/backup_state.json`.
- Zero broken connections post-execution.

## 9. Definition of Done
1. All 10 Vibe Coding Blueprint docs complete in `docs/`.
2. Fully automated scripts (`optimize.ps1`, `benchmark.ps1`, `run.bat`) implemented with elevation handling.
3. Automated test script verifying DNS, ping, adapter properties, and rollback capability passing with 0 errors.
