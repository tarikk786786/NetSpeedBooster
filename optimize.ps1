# optimize.ps1 - Main Entry Script for NetSpeedBooster
[CmdletBinding()]
param(
    [switch]$Auto,
    [switch]$BenchmarkOnly,
    [switch]$Rollback,
    [switch]$WinUtil
)

$PSScriptRootLocal = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$PSScriptRootLocal\src\Benchmark.ps1"
. "$PSScriptRootLocal\src\Optimizer.ps1"
. "$PSScriptRootLocal\src\Rollback.ps1"
. "$PSScriptRootLocal\src\GitHubTools.ps1"

# Check Administrator Elevation
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Show-Header {
    Clear-Host
    Write-Host '==============================================================' -ForegroundColor Cyan
    Write-Host '     NETSPEEDBOOSTER - Windows Network Speed Optimizer         ' -ForegroundColor Cyan
    Write-Host '       Integrating GitHub Open-Source Tools and Intel Tuning   ' -ForegroundColor DarkCyan
    Write-Host '==============================================================' -ForegroundColor Cyan
    if (-not $isAdmin) {
        Write-Host ' [NOTICE] Running without Administrator rights.' -ForegroundColor Yellow
        Write-Host ' Read-only diagnostics work, but applying fixes requires elevation.' -ForegroundColor Yellow
        Write-Host " You can run 'run.bat' to launch with 1-click elevation.`n" -ForegroundColor Yellow
    }
}

function Run-AutoOptimization {
    if (-not $isAdmin) {
        Write-Host "`n[!] Requesting Administrator privileges to apply network changes..." -ForegroundColor Yellow
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Auto"
        return
    }

    Write-Host "`n>>> Step 1/4: Backing up current network state..." -ForegroundColor Cyan
    Backup-CurrentNetworkState

    Write-Host "`n>>> Step 2/4: Benchmarking DNS speeds (pre-optimization)..." -ForegroundColor Cyan
    $preBench = Get-DnsLatencyBenchmark
    $preBench | Format-Table -AutoSize

    Write-Host "`n>>> Step 3/4: Applying Cloudflare Ultra-Low Latency DNS (1.1.1.1 and 1.0.0.1)..." -ForegroundColor Cyan
    Set-FastDns -InterfaceAlias "Wi-Fi" -DnsServers @("1.1.1.1", "1.0.0.1")

    Write-Host "`n>>> Step 4/4: Optimizing Wi-Fi Adapter (Intel 5GHz Preference and Throughput Booster)..." -ForegroundColor Cyan
    Optimize-WifiAdapter -InterfaceAlias "Wi-Fi"
    Clear-NetworkCaches

    Write-Host "`n==============================================================" -ForegroundColor Green
    Write-Host '          ALL NETWORK OPTIMIZATIONS COMPLETED SUCCESSFULLY!    ' -ForegroundColor Green
    Write-Host '==============================================================' -ForegroundColor Green

    Write-Host "`n>>> Verifying new DNS query performance..." -ForegroundColor Cyan
    $postBench = Get-DnsLatencyBenchmark -Domains @('cloudflare.com', 'google.com', 'github.com') -DnsServers @('1.1.1.1', '1.0.0.1')
    $postBench | Format-Table -AutoSize

    Write-Host '[TIP] To undo all changes at any time, run: .\optimize.ps1 -Rollback' -ForegroundColor Gray
}

if ($Auto) {
    Show-Header
    Run-AutoOptimization
    exit
}

if ($BenchmarkOnly) {
    Show-Header
    Write-Host "`n>>> Running Comprehensive DNS and Network Benchmark..." -ForegroundColor Cyan
    $bench = Get-DnsLatencyBenchmark
    $bench | Format-Table -AutoSize
    exit
}

if ($Rollback) {
    Show-Header
    if (-not $isAdmin) {
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Rollback"
        exit
    }
    Restore-NetworkBackup
    exit
}

if ($WinUtil) {
    Invoke-ChrisTitusWinUtil
    exit
}

# Interactive Menu
Show-Header
Write-Host 'Select an option:' -ForegroundColor White
Write-Host '  [1] 1-Click Auto Optimize (Backup, Fast Cloudflare DNS, Intel Wi-Fi Tuning, Flush Cache)' -ForegroundColor Green
Write-Host '  [2] Run DNS and Network Latency Benchmark Only (Safe read-only test)' -ForegroundColor Cyan
Write-Host '  [3] Launch Chris Titus WinUtil (GitHub Open Source OS and Network Tweaker)' -ForegroundColor Yellow
Write-Host '  [4] View Recommended Free GitHub Network Tools' -ForegroundColor DarkCyan
Write-Host '  [5] Rollback / Restore Previous Settings from Backup' -ForegroundColor Magenta
Write-Host '  [Q] Exit' -ForegroundColor Gray

$choice = Read-Host "`nEnter choice [1-5, Q]"
switch ($choice) {
    '1' { Run-AutoOptimization }
    '2' {
        Write-Host "`n>>> Running DNS Benchmark..." -ForegroundColor Cyan
        Get-DnsLatencyBenchmark | Format-Table -AutoSize
    }
    '3' { Invoke-ChrisTitusWinUtil }
    '4' { Show-GitHubToolRecommendations }
    '5' {
        if (-not $isAdmin) {
            Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Rollback"
        } else {
            Restore-NetworkBackup
        }
    }
    default { Write-Host 'Exiting.' }
}
