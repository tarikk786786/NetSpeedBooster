# Code Conventions & Style Guide — NetSpeedBooster

## 1. Core Principles
- **Explicit Cmdlets**: Never use cryptic aliases like `gci`, `select`, or `sc` in committed scripts. Use full cmdlet names (`Get-ChildItem`, `Select-Object`, `Set-Content`).
- **Structured Error Handling**: Wrap all CIM, WMI, and network mutators in `try { ... } catch { ... }` blocks with descriptive error messages.
- **Pure Functions**: Separate diagnostics/benchmarking from state modification.

## 2. Naming Conventions
- Functions: Approved PowerShell Verb-Noun format (e.g., `Invoke-NetOptimization`, `Get-DnsLatencyBenchmark`, `Restore-NetBackup`).
- Variables: PascalCase for public parameters and global configuration, camelCase for loop variables.
- Output: Return rich PowerShell custom objects (`[PSCustomObject]`) rather than formatted strings so they can be piped and tested programmatically.

## 3. Do's and Don'ts
- **DO**: Verify network connectivity after applying changes.
- **DO**: Check for Administrator privileges before attempting mutation.
- **DON'T**: Modify registry keys without recording previous values.
- **DON'T**: Silently fail on network adapter restarts.
