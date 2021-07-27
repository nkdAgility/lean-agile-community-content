function RequiredModule
{
    Param (
        [Parameter(Mandatory=$true)][String] $ModuleName,
        [Parameter(Mandatory=$false)][String] $RequiredVersion
    )

    Write-InfoLog "Module {ModuleName} is required." -PropertyValues $ModuleName
    if ((Get-Module -Name $ModuleName -ListAvailable).count -eq 0) {
        Write-WarningLog "Module {ModuleName} Installing." -PropertyValues $ModuleName
        if ($RequiredVersion -eq $null)
        {
            Install-Module -Name $ModuleName -AllowClobber -Scope CurrentUser -force
        } else
        {
            Install-Module -Name $ModuleName -AllowPrerelease -RequiredVersion $RequiredVersion -Scope CurrentUser -force
        }
    } else {
    Write-InfoLog "Module {ModuleName} Installed." -PropertyValues $ModuleName
    }
    if ((Get-Module -Name $ModuleName).count -eq 0) {
        Write-WarningLog "Module {ModuleName} loading." -PropertyValues $ModuleName
        Update-Module $ModuleName
        Import-Module $ModuleName
    } else {
        Write-InfoLog "Module {ModuleName} Loaded." -PropertyValues $ModuleName
    }
}