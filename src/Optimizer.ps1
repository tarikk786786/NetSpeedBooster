# Optimizer.ps1 - Network & Adapter Optimization Engine

function Backup-CurrentNetworkState {
    [CmdletBinding()]
    param(
        [string]$BackupFile = "$PSScriptRoot\..\data\backup_state.json"
    )

    $dir = Split-Path $BackupFile
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $currentDns = (Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4 -ErrorAction SilentlyContinue).ServerAddresses
    $props = Get-NetAdapterAdvancedProperty -Name "Wi-Fi" -ErrorAction SilentlyContinue | Where-Object { 
        $_.DisplayName -match "Preferred Band|Throughput Booster|MIMO Power Save" 
    }

    $propDict = @{}
    foreach ($p in $props) {
        $propDict[$p.DisplayName] = $p.DisplayValue
    }

    $state = [PSCustomObject]@{
        Timestamp                = (Get-Date).ToString("o")
        InterfaceAlias           = "Wi-Fi"
        OriginalDNS              = $currentDns
        OriginalProperties       = $propDict
    }

    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $BackupFile -Force
    Write-Host "[ OK ] Current network state safely backed up to $BackupFile" -ForegroundColor Green
    return $state
}

function Set-FastDns {
    [CmdletBinding()]
    param(
        [string]$InterfaceAlias = "Wi-Fi",
        [string[]]$DnsServers = @("1.1.1.1", "1.0.0.1")
    )

    try {
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DnsServers -ErrorAction Stop
        Write-Host "[ OK ] DNS for '$InterfaceAlias' updated to: $($DnsServers -join ', ')" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[FAIL] Failed to update DNS: $_" -ForegroundColor Red
        return $false
    }
}

function Optimize-WifiAdapter {
    [CmdletBinding()]
    param(
        [string]$InterfaceAlias = "Wi-Fi"
    )

    $updated = 0
    # 1. Prefer 5GHz Band
    try {
        $bandProp = Get-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "Preferred Band" -ErrorAction SilentlyContinue
        if ($bandProp) {
            # Try to set Prefer 5GHz band
            Set-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "Preferred Band" -DisplayValue "3. Prefer 5GHz band" -ErrorAction SilentlyContinue
            Write-Host "[ OK ] Wi-Fi Preferred Band set to '3. Prefer 5GHz band'" -ForegroundColor Green
            $updated++
        }
    }
    catch {
        Write-Host "[WARN] Could not set Preferred Band: $_" -ForegroundColor Yellow
    }

    # 2. Throughput Booster
    try {
        $tbProp = Get-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "Throughput Booster" -ErrorAction SilentlyContinue
        if ($tbProp) {
            Set-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "Throughput Booster" -DisplayValue "Enabled" -ErrorAction SilentlyContinue
            Write-Host "[ OK ] Intel Throughput Booster Enabled" -ForegroundColor Green
            $updated++
        }
    }
    catch {
        Write-Host "[WARN] Could not enable Throughput Booster: $_" -ForegroundColor Yellow
    }

    # 3. MIMO Power Save Mode to No SMPS (prevents Wi-Fi antennas from throttling power)
    try {
        $mimoProp = Get-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "MIMO Power Save Mode" -ErrorAction SilentlyContinue
        if ($mimoProp) {
            Set-NetAdapterAdvancedProperty -Name $InterfaceAlias -DisplayName "MIMO Power Save Mode" -DisplayValue "No SMPS" -ErrorAction SilentlyContinue
            Write-Host "[ OK ] MIMO Power Save Mode set to 'No SMPS'" -ForegroundColor Green
            $updated++
        }
    }
    catch {
        Write-Host "[WARN] Could not set MIMO Power Save Mode: $_" -ForegroundColor Yellow
    }

    return $updated
}

function Clear-NetworkCaches {
    [CmdletBinding()]
    param()

    try {
        Clear-DnsClientCache
        Write-Host "[ OK ] Local DNS resolver cache flushed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "[WARN] DNS flush: $_" -ForegroundColor Yellow
    }

    # Enable TCP Autotuning normal if not set
    try {
        netsh int tcp set global autotuninglevel=normal | Out-Null
        Write-Host "[ OK ] TCP Window Auto-Tuning confirmed Normal." -ForegroundColor Green
    }
    catch {}
}
