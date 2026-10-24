# Test-NetSpeedBooster.ps1 - Automated Verification Test Suite
$ErrorActionPreference = "Stop"
$testDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$projectRoot = Split-Path -Parent $testDir

. "$projectRoot\src\Benchmark.ps1"
. "$projectRoot\src\Optimizer.ps1"
. "$projectRoot\src\Rollback.ps1"
. "$projectRoot\src\GitHubTools.ps1"

$testsPassed = 0
$testsFailed = 0

function Assert-Test {
    param(
        [string]$Description,
        [scriptblock]$TestBlock
    )
    try {
        $result = & $TestBlock
        if ($result -ne $false) {
            Write-Host "[ PASS ] $Description" -ForegroundColor Green
            $global:testsPassed++
        }
        else {
            Write-Host "[ FAIL ] $Description (Returned false)" -ForegroundColor Red
            $global:testsFailed++
        }
    }
    catch {
        Write-Host "[ FAIL ] $Description ($($_))" -ForegroundColor Red
        $global:testsFailed++
    }
}

Write-Host "`n>>> Running NetSpeedBooster Automated Test Suite..." -ForegroundColor Cyan

# Test 1: Get-NetworkHealthSnapshot
Assert-Test "Network Health Snapshot accurately reports Wi-Fi adapter" {
    $snapshot = Get-NetworkHealthSnapshot
    $snapshot -ne $null -and $snapshot.AdapterName -eq "Wi-Fi"
}

# Test 2: DNS Benchmark Engine
Assert-Test "DNS Benchmark Engine resolves domains across Cloudflare and Quad9" {
    $bench = Get-DnsLatencyBenchmark -Domains @('cloudflare.com') -DnsServers @('1.1.1.1', '9.9.9.9')
    $bench.Count -ge 2 -and ($bench[0].AvgQueryMs -lt 5000)
}

# Test 3: Backup serialization & schema validation
Assert-Test "Backup engine creates valid JSON state file" {
    $tempBackup = "$projectRoot\data\test_backup.json"
    $state = Backup-CurrentNetworkState -BackupFile $tempBackup
    $exists = Test-Path $tempBackup
    $parsed = Get-Content $tempBackup -Raw | ConvertFrom-Json
    Remove-Item $tempBackup -Force -ErrorAction SilentlyContinue
    $exists -and ($parsed.InterfaceAlias -eq "Wi-Fi") -and ($parsed.Timestamp -ne $null)
}

# Test 4: Rollback logic handles non-existent file gracefully
Assert-Test "Rollback returns false safely if backup file does not exist" {
    $res = Restore-NetworkBackup -BackupFile "$projectRoot\data\non_existent.json"
    $res -eq $false
}

# Test 5: Connectivity verification
Assert-Test "Internet DNS resolution is currently active and healthy" {
    $resolve = Resolve-DnsName -Name "github.com" -ErrorAction Stop
    $resolve -ne $null
}

Write-Host "`n==============================================================" -ForegroundColor Cyan
Write-Host " Test Results: Passed = $testsPassed, Failed = $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host "==============================================================`n" -ForegroundColor Cyan

if ($testsFailed -gt 0) {
    exit 1
}
exit 0
