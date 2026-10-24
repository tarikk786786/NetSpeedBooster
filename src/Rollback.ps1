# Rollback.ps1 - Safe Restoration Engine

function Restore-NetworkBackup {
    [CmdletBinding()]
    param(
        [string]$BackupFile = "$PSScriptRoot\..\data\backup_state.json"
    )

    if (-not (Test-Path $BackupFile)) {
        Write-Host "[FAIL] No backup file found at $BackupFile" -ForegroundColor Red
        return $false
    }

    try {
        $state = Get-Content $BackupFile -Raw | ConvertFrom-Json
        $alias = $state.InterfaceAlias

        # Restore DNS
        if ($state.OriginalDNS -and $state.OriginalDNS.Count -gt 0) {
            Set-DnsClientServerAddress -InterfaceAlias $alias -ServerAddresses $state.OriginalDNS -ErrorAction Stop
            Write-Host "[ OK ] Restored DNS to original: $($state.OriginalDNS -join ', ')" -ForegroundColor Green
        }
        else {
            # Reset to DHCP automatic DNS
            Set-DnsClientServerAddress -InterfaceAlias $alias -ResetServerAddresses -ErrorAction Stop
            Write-Host "[ OK ] Reset DNS to automatic (DHCP)" -ForegroundColor Green
        }

        # Restore adapter properties
        if ($state.OriginalProperties) {
            foreach ($prop in $state.OriginalProperties.PSObject.Properties) {
                try {
                    Set-NetAdapterAdvancedProperty -Name $alias -DisplayName $prop.Name -DisplayValue $prop.Value -ErrorAction SilentlyContinue
                    Write-Host "[ OK ] Restored '$($prop.Name)' -> $($prop.Value)" -ForegroundColor Green
                }
                catch {}
            }
        }

        Clear-DnsClientCache -ErrorAction SilentlyContinue
        Write-Host "[ OK ] Network state successfully reverted to baseline snapshot." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[FAIL] Failed to restore backup: $_" -ForegroundColor Red
        return $false
    }
}

if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Restore-NetworkBackup
}
