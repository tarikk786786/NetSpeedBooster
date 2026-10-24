# GitHubTools.ps1 - Launcher for Vetted GitHub Open-Source Network Tools

function Invoke-ChrisTitusWinUtil {
    Write-Host "`n[INFO] Launching Chris Titus WinUtil (GitHub: ChrisTitusTech/winutil)..." -ForegroundColor Cyan
    Write-Host "In the WinUtil GUI, navigate to the 'Tweaks' tab to enable Network Optimizations and DNS Tweaks.`n" -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit -Command `"irm 'https://christitus.com/win' | iex`""
}

function Show-GitHubToolRecommendations {
    Write-Host "`n==============================================================" -ForegroundColor Cyan
    Write-Host "     TOP VERIFIED GITHUB OPEN-SOURCE NETWORK & SPEED TOOLS     " -ForegroundColor Cyan
    Write-Host "==============================================================" -ForegroundColor Cyan

    $tools = @(
        [PSCustomObject]@{
            Name = "ChrisTitusTech / winutil"
            URL  = "https://github.com/ChrisTitusTech/winutil"
            Use  = "Windows Network & OS Tweaks, DNS changer, TCP optimizer, disable telemetry"
        },
        [PSCustomObject]@{
            Name = "ValdikSS / GoodbyeDPI"
            URL  = "https://github.com/ValdikSS/GoodbyeDPI"
            Use  = "Bypass ISP Deep Packet Inspection, unblock throttled videos & downloads"
        },
        [PSCustomObject]@{
            Name = "cleanbrowsing / dnsperftest"
            URL  = "https://github.com/cleanbrowsing/dnsperftest"
            Use  = "DNS benchmark tool comparing latency across major global resolvers"
        },
        [PSCustomObject]@{
            Name = "librespeed / speedtest-cli"
            URL  = "https://github.com/librespeed/speedtest-cli"
            Use  = "Lightweight open-source internet bandwidth & bufferbloat testing"
        }
    )

    $tools | Format-Table -AutoSize
}
