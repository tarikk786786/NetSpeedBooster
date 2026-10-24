# User Experience Flows — NetSpeedBooster

## 1. Primary Flow: 1-Click Fast Optimization
```mermaid
sequenceDiagram
    actor User
    participant Launcher as run.bat
    participant UAC as Windows UAC
    participant Core as optimize.ps1
    participant System as Network Stack
    
    User->>Launcher: Double clicks run.bat
    Launcher->>UAC: Check IsAdmin
    alt Not Admin
        UAC-->>User: Elevation Prompt ("Yes")
        Launcher->>Core: Starts elevated process
    else Already Admin
        Launcher->>Core: Direct execution
    end
    Core->>System: Snapshot current state to backup_state.json
    Core->>System: Benchmark current vs Cloudflare DNS
    Core->>System: Apply Cloudflare 1.1.1.1 + 1.0.0.1
    Core->>System: Tune Intel AX211 Wi-Fi settings
    Core->>System: Flush DNS and reset socket caches
    Core-->>User: Displays Before/After Latency Table and Success Notice
```

## 2. Interactive Flow: Menu Options
1. **[1] 1-Click Auto Optimize** (Recommended — Benchmark, Fast DNS, Intel Wi-Fi Tuning, Flush Cache)
2. **[2] DNS Benchmark Only** (Compare current vs Cloudflare, Google, Quad9, OpenDNS)
3. **[3] Launch Chris Titus WinUtil** (Open source GitHub utility for OS-level network debloat)
4. **[4] Launch GoodbyeDPI** (Bypass ISP throttling and DPI)
5. **[5] Rollback to Original Settings** (Restore state from backup)
6. **[6] Run Self-Test Suite**
