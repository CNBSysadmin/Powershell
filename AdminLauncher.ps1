[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="AdminLauncher" Height="350" Width="525">
	<Grid HorizontalAlignment="Left" Height="263" Margin="19,26,0,0" VerticalAlignment="Top" Width="479">
		<Button Name="btnSCCM" Content="SCCM" HorizontalAlignment="Left" Margin="77,70,0,0" VerticalAlignment="Top" Width="85" ClickMode="Press" Height="50"/>
		<TextBox Name="txtUserName" HorizontalAlignment="Left" Height="23" Margin="126,10,0,0" TextWrapping="Wrap" Text="CNB-SS\justin.hibbard.admin" VerticalAlignment="Top" Width="227"/>
		<Button Name="btnSCOM" Content="SCOM" HorizontalAlignment="Left" Margin="202,70,0,0" VerticalAlignment="Top" Width="85" ClickMode="Press" Height="50"/>
		<Button Name="btnPoSH" Content="PowerShell" HorizontalAlignment="Left" Margin="327,70,0,0" VerticalAlignment="Top" Width="85" ClickMode="Press" Height="50"/>
		<Button Name="btnVSphere" Content="vCenter-VC02" HorizontalAlignment="Left" Margin="77,165,0,0" VerticalAlignment="Top" Width="85" Height="50" FontSize="10.667"/>
		<Button Name="btnServerManager" Content="Server Manager" HorizontalAlignment="Left" Margin="202,165,0,0" VerticalAlignment="Top" Width="85" Height="50" FontSize="10.667"/>
		<Button Name="btnSSMS" Content="SQL MS" HorizontalAlignment="Left" Margin="327,165,0,0" VerticalAlignment="Top" Width="85" Height="50" FontSize="10.667"/>
	</Grid>
</Window>


'@

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
#Event Handlers

#===========================================================================
# SCCM onClick Event
#===========================================================================
$btnSCCM.add_Click({
$user = $txtUserName.text
invoke-command  {C:\Windows\System32\runas.exe /savecred /user:$user "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe"}
})
#===========================================================================

#===========================================================================
# SCOM onClick Event
#===========================================================================
$btnSCOM.add_Click({
$user = $txtUserName.text
invoke-command  {C:\Windows\System32\runas.exe /user:$user /savecred "C:\Program Files\Microsoft System Center 2012 R2\Operations Manager\Console\Microsoft.EnterpriseManagement.Monitoring.Console.exe"}
})
#===========================================================================

#===========================================================================
# PoSH onClick Event
#===========================================================================
$btnPoSH.add_Click({
$user = $txtUserName.text
invoke-command  {C:\Windows\System32\runas.exe /savecred /user:$user "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"}
})
#===========================================================================

#===========================================================================
# vCenter onClick Event
#===========================================================================
$btnVSphere.add_Click({
$user = $txtUserName.text
Set-Location 'C:\Program Files (x86)\VMware\Infrastructure\Virtual Infrastructure Client\Launcher'
Invoke-Command	 {C:\Windows\System32\runas.exe /savecred /user:$user "VpxClient.exe -passthroughAuth -s sss-cat-vc02.cnb-ss.com"}
})
#===========================================================================

#===========================================================================
#ServerManager onClick Event
#===========================================================================
$btnServerManager.add_Click({
$user = $txtUserName.text
Invoke-Command  {C:\Windows\System32\runas.exe /savecred /user:$user "C:\Windows\System32\ServerManager.exe"}
})
#===========================================================================

#===========================================================================
#SSMS onClick Event
#===========================================================================
$btnSSMS.add_Click({
$user = $txtUserName.text
Invoke-Command  {C:\Windows\System32\runas.exe /savecred /user:$user "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\Ssms.exe"}
})
#===========================================================================


#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null

