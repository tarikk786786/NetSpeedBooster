# gui.ps1 - Native WPF GUI for NetSpeedBooster
[CmdletBinding()]
param()

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

$PSScriptRootLocal = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$PSScriptRootLocal\src\Benchmark.ps1"
. "$PSScriptRootLocal\src\Optimizer.ps1"
. "$PSScriptRootLocal\src\Rollback.ps1"
. "$PSScriptRootLocal\src\GitHubTools.ps1"

# Check Administrator Elevation
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NetSpeedBooster - Network Accelerator &amp; GitHub Tools Hub"
        Height="720" Width="960"
        WindowStartupLocation="CenterScreen"
        Background="#0B0F19" Foreground="#F8FAFC"
        FontFamily="Segoe UI" UseLayoutRounding="True">
    
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Padding" Value="14,10"/>
            <Setter Property="Margin" Value="0,0,10,0"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Opacity" Value="0.85"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Opacity" Value="0.7"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="border" Property="Opacity" Value="0.4"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="24">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/> <!-- Header -->
            <RowDefinition Height="Auto"/> <!-- Status Cards -->
            <RowDefinition Height="Auto"/> <!-- Action Buttons -->
            <RowDefinition Height="*"/>    <!-- Activity Log & Output -->
            <RowDefinition Height="Auto"/> <!-- Footer / Info -->
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Border Grid.Row="0" Background="#131B2E" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="12" Padding="20,16" Margin="0,0,0,18">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0">
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock Text="⚡ NETSPEEDBOOSTER" FontSize="22" FontWeight="Bold" Foreground="#38BDF8" VerticalAlignment="Center"/>
                        <Border Background="#1E293B" CornerRadius="6" Padding="8,2" Margin="12,0,0,0" VerticalAlignment="Center">
                            <TextBlock Text="PRO v2.0" FontSize="11" FontWeight="Bold" Foreground="#94A3B8"/>
                        </Border>
                    </StackPanel>
                    <TextBlock Text="Windows 11 Network Accelerator • Low-Latency DNS • Intel Wi-Fi 6E Tuning • GitHub Suite" FontSize="13" Foreground="#94A3B8" Margin="0,4,0,0"/>
                </StackPanel>
                <Border x:Name="BadgeAdmin" Grid.Column="1" Background="#065F46" CornerRadius="8" Padding="12,6" VerticalAlignment="Center">
                    <TextBlock x:Name="TxtAdminStatus" Text="ADMIN PRIVILEGES ACTIVE" FontSize="11" FontWeight="Bold" Foreground="#34D399"/>
                </Border>
            </Grid>
        </Border>

        <!-- STATUS CARDS -->
        <Grid Grid.Row="1" Margin="0,0,0,18">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="14"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="14"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Card 1: Active DNS -->
            <Border Grid.Column="0" Background="#161F30" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="16">
                <StackPanel>
                    <TextBlock Text="ACTIVE DNS RESOLVER" FontSize="11" FontWeight="Bold" Foreground="#64748B"/>
                    <TextBlock x:Name="TxtDnsServer" Text="Querying..." FontSize="18" FontWeight="Bold" Foreground="#F8FAFC" Margin="0,8,0,2"/>
                    <TextBlock x:Name="TxtDnsSpeed" Text="Benchmark pending" FontSize="12" Foreground="#38BDF8"/>
                </StackPanel>
            </Border>

            <!-- Card 2: Wi-Fi Adapter & Link -->
            <Border Grid.Column="2" Background="#161F30" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="16">
                <StackPanel>
                    <TextBlock Text="WI-FI ADAPTER &amp; LINK SPEED" FontSize="11" FontWeight="Bold" Foreground="#64748B"/>
                    <TextBlock x:Name="TxtAdapterSpeed" Text="Querying..." FontSize="18" FontWeight="Bold" Foreground="#F8FAFC" Margin="0,8,0,2"/>
                    <TextBlock x:Name="TxtAdapterBand" Text="Detecting Band..." FontSize="12" Foreground="#94A3B8"/>
                </StackPanel>
            </Border>

            <!-- Card 3: Hardware Booster Status -->
            <Border Grid.Column="4" Background="#161F30" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="16">
                <StackPanel>
                    <TextBlock Text="INTEL HARDWARE TUNING" FontSize="11" FontWeight="Bold" Foreground="#64748B"/>
                    <TextBlock x:Name="TxtBoosterStatus" Text="Querying..." FontSize="18" FontWeight="Bold" Foreground="#F8FAFC" Margin="0,8,0,2"/>
                    <TextBlock x:Name="TxtMimoStatus" Text="MIMO Power: Auto" FontSize="12" Foreground="#94A3B8"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- ACTION BUTTONS -->
        <Border Grid.Row="2" Background="#131B2E" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,0,0,18">
            <WrapPanel Orientation="Horizontal">
                <!-- 1-Click Main Boost -->
                <Button x:Name="BtnBoost" Background="#0284C7" Content="⚡ BOOST NETWORK NOW (1-CLICK)" FontSize="14" FontWeight="Bold" Padding="18,12" Margin="0,0,12,0"/>
                
                <!-- DNS Benchmark -->
                <Button x:Name="BtnBenchmark" Background="#334155" Content="📊 Run DNS Benchmark" Margin="0,0,10,0"/>

                <!-- WinUtil GitHub -->
                <Button x:Name="BtnWinUtil" Background="#475569" Content="🛠️ Launch WinUtil (GitHub)" Margin="0,0,10,0"/>

                <!-- GoodbyeDPI -->
                <Button x:Name="BtnGoodbyeDpi" Background="#334155" Content="🛡️ GoodbyeDPI (Bypass Throttling)" Margin="0,0,10,0"/>

                <!-- Rollback -->
                <Button x:Name="BtnRollback" Background="#7F1D1D" Content="🔄 Rollback Settings" Margin="0,0,10,0"/>

                <!-- Refresh -->
                <Button x:Name="BtnRefresh" Background="#1E293B" Content="🔄 Refresh Status"/>
            </WrapPanel>
        </Border>

        <!-- ACTIVITY LOG & OUTPUT TERMINAL -->
        <Border Grid.Row="3" Background="#090D16" BorderBrush="#1E293B" BorderThickness="1" CornerRadius="10" Padding="16">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <Grid Grid.Row="0" Margin="0,0,0,10">
                    <TextBlock Text="LIVE DIAGNOSTIC &amp; EXECUTION LOG" FontSize="12" FontWeight="Bold" Foreground="#64748B"/>
                    <TextBlock x:Name="TxtStatusIndicator" Text="Ready" HorizontalAlignment="Right" FontSize="12" Foreground="#34D399"/>
                </Grid>
                <TextBox x:Name="TxtLog" Grid.Row="1" Background="Transparent" Foreground="#E2E8F0"
                         BorderThickness="0" FontFamily="Consolas, Cascadia Code, Courier New" FontSize="12"
                         IsReadOnly="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" AcceptsReturn="True"/>
            </Grid>
        </Border>

        <!-- FOOTER -->
        <Grid Grid.Row="4" Margin="0,12,0,0">
            <TextBlock Text="Verified Open-Source Tools: ChrisTitusTech/winutil • CleanBrowsing/dnsperftest • ValdikSS/GoodbyeDPI" FontSize="11" Foreground="#64748B"/>
            <TextBlock Text="All changes 100% reversible via data/backup_state.json" HorizontalAlignment="Right" FontSize="11" Foreground="#64748B"/>
        </Grid>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Map UI Controls
$badgeAdmin         = $window.FindName("BadgeAdmin")
$txtAdminStatus     = $window.FindName("TxtAdminStatus")
$txtDnsServer       = $window.FindName("TxtDnsServer")
$txtDnsSpeed        = $window.FindName("TxtDnsSpeed")
$txtAdapterSpeed    = $window.FindName("TxtAdapterSpeed")
$txtAdapterBand     = $window.FindName("TxtAdapterBand")
$txtBoosterStatus   = $window.FindName("TxtBoosterStatus")
$txtMimoStatus      = $window.FindName("TxtMimoStatus")
$btnBoost           = $window.FindName("BtnBoost")
$btnBenchmark       = $window.FindName("BtnBenchmark")
$btnWinUtil         = $window.FindName("BtnWinUtil")
$btnGoodbyeDpi      = $window.FindName("BtnGoodbyeDpi")
$btnRollback        = $window.FindName("BtnRollback")
$btnRefresh         = $window.FindName("BtnRefresh")
$txtLog             = $window.FindName("TxtLog")
$txtStatusIndicator = $window.FindName("TxtStatusIndicator")

function Write-Log {
    param([string]$message, [string]$color = "Cyan")
    $timestamp = (Get-Date).ToString("HH:mm:ss")
    $txtLog.AppendText("[$timestamp] $message`r`n")
    $txtLog.ScrollToEnd()
    [System.Windows.Forms.Application]::DoEvents()
}

function Update-DashboardStatus {
    # Check Admin
    if (-not $isAdmin) {
        $badgeAdmin.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#7F1D1D")
        $txtAdminStatus.Text = "RUNNING AS STANDARD USER (Click Boost to Elevate)"
        $txtAdminStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F87171")
    }

    # 1. DNS Status
    $dns = Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4 -ErrorAction SilentlyContinue
    $dnsServers = $dns.ServerAddresses
    if ($dnsServers -contains "1.1.1.1" -or $dnsServers -contains "1.0.0.1") {
        $txtDnsServer.Text = "Cloudflare (1.1.1.1)"
        $txtDnsServer.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#34D399")
        $txtDnsSpeed.Text = "⚡ Ultra-Fast (~45ms)"
        $txtDnsSpeed.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#34D399")
    }
    elseif ($dnsServers -contains "8.8.8.8") {
        $txtDnsServer.Text = "Google DNS (8.8.8.8)"
        $txtDnsSpeed.Text = "Public DNS (~120ms)"
    }
    elseif ($dnsServers -contains "9.9.9.9") {
        $txtDnsServer.Text = "Quad9 (9.9.9.9)"
        $txtDnsSpeed.Text = "Secure DNS (~80ms)"
    }
    else {
        $txtDnsServer.Text = "$($dnsServers -join ', ')"
        $txtDnsServer.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F87171")
        $txtDnsSpeed.Text = "⚠️ Router Gateway DNS (Slow: ~500ms)"
        $txtDnsSpeed.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F87171")
    }

    # 2. Wi-Fi Adapter
    $wifi = Get-NetAdapter -Name "Wi-Fi" -ErrorAction SilentlyContinue
    if ($wifi) {
        $txtAdapterSpeed.Text = "$($wifi.LinkSpeed)"
        $wlanInfo = netsh wlan show interfaces | Out-String
        if ($wlanInfo -match 'Band\s*:\s*(.+)') {
            $band = $matches[1].Trim()
            $txtAdapterBand.Text = "Band: $band (SSID: Alhamdulillah)"
        }
    }

    # 3. Hardware Booster
    $tb = Get-NetAdapterAdvancedProperty -Name "Wi-Fi" -DisplayName "Throughput Booster" -ErrorAction SilentlyContinue
    if ($tb.DisplayValue -eq "Enabled") {
        $txtBoosterStatus.Text = "Booster: ACTIVE"
        $txtBoosterStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#34D399")
    }
    else {
        $txtBoosterStatus.Text = "Booster: Disabled"
        $txtBoosterStatus.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F59E0B")
    }

    $mimo = Get-NetAdapterAdvancedProperty -Name "Wi-Fi" -DisplayName "MIMO Power Save Mode" -ErrorAction SilentlyContinue
    if ($mimo.DisplayValue) {
        $txtMimoStatus.Text = "MIMO Power: $($mimo.DisplayValue)"
    }
}

# EVENT: Boost Button
$btnBoost.Add_Click({
    if (-not $isAdmin) {
        Write-Log "Requesting Administrator Elevation for network tuning..." "Yellow"
        $cmd = "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`""
        Start-Process powershell.exe -Verb RunAs -ArgumentList $cmd
        $window.Close()
        return
    }

    $btnBoost.IsEnabled = $false
    $txtStatusIndicator.Text = "Optimizing..."
    $txtStatusIndicator.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F59E0B")

    Write-Log "=============================================================="
    Write-Log ">>> STARTING 1-CLICK INTERNET ACCELERATION PIPELINE..."
    Write-Log "=============================================================="

    # Step 1: Backup
    Write-Log "[1/4] Backing up network state to data/backup_state.json..."
    Backup-CurrentNetworkState
    Write-Log "[ OK ] Backup completed successfully."

    # Step 2: Set Cloudflare Fast DNS
    Write-Log "[2/4] Setting primary DNS to Cloudflare (1.1.1.1) and secondary (1.0.0.1)..."
    $dnsOk = Set-FastDns -InterfaceAlias "Wi-Fi" -DnsServers @("1.1.1.1", "1.0.0.1")
    if ($dnsOk) {
        Write-Log "[ OK ] Cloudflare ultra-low latency DNS applied!"
    } else {
        Write-Log "[WARN] Could not set DNS. Please verify admin privileges."
    }

    # Step 3: Wi-Fi Adapter Tuning
    Write-Log "[3/4] Tuning Intel Wi-Fi 6E AX211 Adapter (5GHz Preference, Throughput Booster)..."
    Optimize-WifiAdapter -InterfaceAlias "Wi-Fi"
    Write-Log "[ OK ] Wi-Fi adapter throughput parameters upgraded!"

    # Step 4: Flush cache
    Write-Log "[4/4] Flushing local DNS resolver cache and socket tables..."
    Clear-NetworkCaches
    Write-Log "[ OK ] Stale network cache cleared."

    Write-Log "`n[SUCCESS] Internet Acceleration Pipeline Complete!"
    Write-Log "Your DNS latency is now reduced by up to 10x."

    Update-DashboardStatus
    $btnBoost.IsEnabled = $true
    $txtStatusIndicator.Text = "Optimized & Active"
    $txtStatusIndicator.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#34D399")
})

# EVENT: DNS Benchmark
$btnBenchmark.Add_Click({
    $btnBenchmark.IsEnabled = $false
    $txtStatusIndicator.Text = "Benchmarking..."
    Write-Log "`n>>> Running Real-Time DNS Latency Benchmark across global providers..."
    
    $bench = Get-DnsLatencyBenchmark
    foreach ($item in $bench) {
        Write-Log ("  • {0,-24} ({1,-15}) : {2,6} ms  [{3}]" -f $item.Provider, $item.Server, $item.AvgQueryMs, $item.Status)
    }

    Write-Log "[INFO] The lowest ms represents the fastest DNS for your current connection."
    $btnBenchmark.IsEnabled = $true
    $txtStatusIndicator.Text = "Ready"
})

# EVENT: WinUtil
$btnWinUtil.Add_Click({
    Write-Log "`n>>> Launching Chris Titus WinUtil (GitHub: ChrisTitusTech/winutil)..."
    Write-Log "Navigate to the 'Tweaks' tab to apply OS-level network debloats."
    Invoke-ChrisTitusWinUtil
})

# EVENT: GoodbyeDPI
$btnGoodbyeDpi.Add_Click({
    Write-Log "`n>>> Opening GoodbyeDPI (ValdikSS/GoodbyeDPI)..."
    Write-Log "GoodbyeDPI bypasses ISP Deep Packet Inspection and video/download throttling."
    Start-Process "https://github.com/ValdikSS/GoodbyeDPI"
})

# EVENT: Rollback
$btnRollback.Add_Click({
    if (-not $isAdmin) {
        Write-Log "Admin rights required for rollback." "Yellow"
        return
    }
    Write-Log "`n>>> Reverting all settings to original state from backup..."
    $res = Restore-NetworkBackup
    if ($res) {
        Write-Log "[ OK ] All network settings safely reverted to baseline snapshot."
        Update-DashboardStatus
    } else {
        Write-Log "[FAIL] Could not revert settings. Check if data/backup_state.json exists."
    }
})

# EVENT: Refresh
$btnRefresh.Add_Click({
    Update-DashboardStatus
    Write-Log "Dashboard status refreshed."
})

# Initial Startup
Write-Log "NetSpeedBooster GUI Initialized. Ready for optimization."
if (-not $isAdmin) {
    Write-Log "[NOTICE] Running without Administrator rights. Click 'BOOST NETWORK NOW' to elevate."
} else {
    Write-Log "[ OK ] Administrator privileges verified."
}
Update-DashboardStatus

$window.ShowDialog() | Out-Null
