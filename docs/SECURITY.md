# Security Guidelines — NetSpeedBooster

## 1. Privilege Elevation & Scope
- **Least Privilege Principle**: Read-only diagnostics run without elevation. Modification commands only request UAC elevation when modifying system-wide DNS and NIC properties.
- **Elevation Transparency**: UAC requests explicitly display PowerShell invoking `optimize.ps1` with no obfuscation or hidden scripts.

## 2. Remote Scripts & Supply Chain Security
- All embedded code is 100% local and inspectable in `src/`.
- Any external GitHub scripts (such as ChrisTitusTech `winutil`) are only called upon explicit user selection via menu, using verified HTTPS endpoints (`https://christitus.com/win` / official GitHub repositories).
- No sensitive credentials, tokens, or personal identifiers are collected or stored.

## 3. Network Safety & Rollback Guarantee
- Every configuration mutation creates a snapshot in `data/backup_state.json`.
- In the event of network disruption, `Rollback.ps1` restores the exact pre-existing DNS and adapter configuration.
