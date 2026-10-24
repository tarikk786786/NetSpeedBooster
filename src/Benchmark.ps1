# Benchmark.ps1 - Network & DNS Benchmark Engine
function Get-DnsLatencyBenchmark {
    [CmdletBinding()]
    param(
        [string[]]$Domains = @('cloudflare.com', 'google.com', 'github.com'),
        [string[]]$DnsServers = @('192.168.29.1', '1.1.1.1', '1.0.0.1', '9.9.9.9', '8.8.8.8', '208.67.222.222')
    )

    $results = @()
    foreach ($dns in $DnsServers) {
        $times = @()
        $providerName = switch ($dns) {
            '192.168.29.1'   { 'Current Router (Local)' }
            '1.1.1.1'        { 'Cloudflare Primary' }
            '1.0.0.1'        { 'Cloudflare Secondary' }
            '9.9.9.9'        { 'Quad9 (Secure)' }
            '8.8.8.8'        { 'Google Public DNS' }
            '208.67.222.222' { 'OpenDNS' }
            default          { 'Custom DNS' }
        }

        foreach ($domain in $Domains) {
            try {
                $sw = [System.Diagnostics.Stopwatch]::StartNew()
                $res = Resolve-DnsName -Name $domain -Server $dns -QuickTimeout -Type A -ErrorAction Stop
                $sw.Stop()
                if ($res) {
                    $times += $sw.Elapsed.TotalMilliseconds
                }
            }
            catch {
                # Timeout or blocked
            }
        }

        if ($times.Count -gt 0) {
            $avg = ($times | Measure-Object -Average).Average
            $results += [PSCustomObject]@{
                Provider     = $providerName
                Server       = $dns
                AvgQueryMs   = [math]::Round($avg, 1)
                SuccessCount = "$($times.Count)/$($Domains.Count)"
                Status       = 'Online'
            }
        }
        else {
            $results += [PSCustomObject]@{
                Provider     = $providerName
                Server       = $dns
                AvgQueryMs   = 9999
                SuccessCount = "0/$($Domains.Count)"
                Status       = 'Unresponsive'
            }
        }
    }

    return ($results | Sort-Object AvgQueryMs)
}

function Get-NetworkHealthSnapshot {
    [CmdletBinding()]
    param()

    $wifi = Get-NetAdapter -Name "Wi-Fi" -ErrorAction SilentlyContinue
    $dns = Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4 -ErrorAction SilentlyContinue

    return [PSCustomObject]@{
        AdapterName      = $wifi.Name
        LinkSpeed        = $wifi.LinkSpeed
        Status           = $wifi.Status
        CurrentDns       = ($dns.ServerAddresses -join ', ')
        AutoTuningLevel  = (Get-NetTCPSetting -SettingName Internet -ErrorAction SilentlyContinue).AutoTuningLevelLocal
        CongestionCtrl   = (Get-NetTCPSetting -SettingName Internet -ErrorAction SilentlyContinue).CongestionProvider
    }
}
