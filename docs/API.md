# API Contracts & Public Functions — NetSpeedBooster

## 1. PowerShell Public Module Interface

### `Get-DnsLatencyBenchmark`
- **Description**: Benchmarks DNS resolution latency across given target domains and DNS servers.
- **Inputs**:
  - `[string[]]$Domains` (Default: `@('cloudflare.com', 'google.com', 'github.com')`)
  - `[string[]]$DnsServers` (Default: `@('1.1.1.1', '1.0.0.1', '9.9.9.9', '8.8.8.8')`)
- **Returns**: `[PSCustomObject[]]` with properties `DNS_Server`, `AvgQueryMs`, `Status`.

### `Invoke-NetOptimization`
- **Description**: Applies recommended DNS servers and adapter optimizations.
- **Inputs**:
  - `[string]$InterfaceAlias = "Wi-Fi"`
  - `[string[]]$DnsServers = @("1.1.1.1", "1.0.0.1")`
  - `[switch]$OptimizeHardware`
- **Returns**: `[PSCustomObject]` with properties `DnsUpdated`, `HardwareUpdated`, `FlushedCache`, `Status`.

### `Restore-NetBackup`
- **Description**: Reverts all settings using `data/backup_state.json`.
- **Inputs**:
  - `[string]$BackupPath = "data/backup_state.json"`
- **Returns**: `[bool]$Success`.

### `Invoke-GitHubWinUtil`
- **Description**: Launches the Chris Titus Tech Windows Utility (`irm https://christitus.com/win | iex`) in a new elevated PowerShell window.
