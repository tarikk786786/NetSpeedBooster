# NetSpeedBooster — Windows Network Accelerator & GitHub Hub

> Automated Windows network diagnostic, DNS accelerator, and Wi-Fi adapter tuning suite leveraging verified open-source GitHub tools.

---

## ⚡ Features

1. **Ultra-Fast DNS Switching**:
   - Replaces sluggish local router/ISP DNS (~470ms latency) with Cloudflare (`1.1.1.1` and `1.0.0.1`) for ~45ms lookups (up to **10x faster** domain resolution).
2. **Intel Wi-Fi 6E AX211 Hardware Optimization**:
   - Sets **Preferred Band** to `Prefer 5GHz band` (locks out slow 2.4GHz drops).
   - Enables **Throughput Booster** for packet bursting.
   - Sets **MIMO Power Save Mode** to `No SMPS` to prevent antenna power throttling.
3. **Safe Snapshot & 100% Rollback**:
   - Automatically snapshots existing network configuration into `data/backup_state.json` before any changes.
   - Run `optimize.ps1 -Rollback` anytime to instantly restore baseline settings.
4. **GitHub Open-Source Tools Integration**:
   - **ChrisTitusTech/winutil**: Dedicated OS and network debloating utility.
   - **ValdikSS/GoodbyeDPI**: Bypass ISP packet filtering and artificial video throttling.
   - **cleanbrowsing/dnsperftest**: In-depth multi-resolver benchmark.
   - **librespeed/speedtest-cli**: Ad-free, open-source bandwidth test.

---

## 🚀 How to Run

### Option 1: Desktop Homescreen Shortcut (Recommended)
Double-click the **`Net Speed Booster`** shortcut icon directly on your Windows Desktop homescreen. It is pre-configured with administrator elevation and launches the Fluent Dark Mode GUI dashboard.

### Option 2: 1-Click GUI via Batch
Double-click [`run_gui.bat`](run_gui.bat) or [`run_auto.bat`](run_auto.bat).

### Option 3: PowerShell CLI
To run fully automated optimization:
```powershell
powershell -ExecutionPolicy Bypass -File .\apps\NetSpeedBooster\optimize.ps1 -Auto
```

To run a safe read-only DNS benchmark:
```powershell
powershell -ExecutionPolicy Bypass -File .\apps\NetSpeedBooster\optimize.ps1 -BenchmarkOnly
```

To launch Chris Titus WinUtil:
```powershell
powershell -ExecutionPolicy Bypass -File .\apps\NetSpeedBooster\optimize.ps1 -WinUtil
```

To revert/rollback anytime:
```powershell
powershell -ExecutionPolicy Bypass -File .\apps\NetSpeedBooster\optimize.ps1 -Rollback
```

---

## 🧪 Verification & Automated Tests

Run the test suite:
```powershell
powershell -ExecutionPolicy Bypass -File .\apps\NetSpeedBooster\tests\Test-NetSpeedBooster.ps1
```

All 5 test assertions cover adapter health, live DNS benchmarks, schema integrity, and rollback validation.

---

## 📁 Project Architecture & Vibe Coding Blueprint

All 10 blueprint specifications reside in `docs/`:
- [`PRD.md`](docs/PRD.md)
- [`ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- [`DATABASE.md`](docs/DATABASE.md)
- [`DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md)
- [`SECURITY.md`](docs/SECURITY.md)
- [`CODE_STYLE.md`](docs/CODE_STYLE.md)
- [`TESTING.md`](docs/TESTING.md)
- [`AGENTS.md`](docs/AGENTS.md)
- [`UX_FLOWS.md`](docs/UX_FLOWS.md)
- [`API.md`](docs/API.md)
