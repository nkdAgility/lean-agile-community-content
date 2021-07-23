if ($PSVersionTable.PSEdition -eq 'Core' -and (Get-Module -Name PoShLog -ListAvailable).count -eq 0) {
    Write-Warning -Message ('Module PoshLog Missing.')
    Install-Module -Name PoShLog -AllowClobber -Scope CurrentUser -force
} else {
   Write-Information -Message ('Module PoshLog Detected.')
}
If ($logger -eq $null)
{
    $date = Get-Date
    $DateStr = $Date.ToString("yyyyMMddHms")
    Import-Module PoShLog
    # Create new logger
    $logger = New-Logger | Set-MinimumLevel -Value Verbose | Add-SinkConsole | Add-SinkFile -Path "$PSScriptRoot\logs\log-$DateStr.txt"
    Start-Logger -LoggerConfig $logger
    Write-InfoLog "LOGGER: Started"
} else {
    Write-InfoLog "LOGGER: Running"
}

   