param([Parameter(Mandatory=$false)] [string]$version)

if ($version -eq $null)
{
    $version = "0.0.0"
}

Set-Location $PSScriptRoot
. .\include-logging.ps1
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "Build ALL v{version}" -PropertyValues $version
. .\include-variables.ps1
Write-InfoLog "========================================================"

# Find all content.json

$projects = Get-ChildItem -Filter project.json -Recurse
Write-InfoLog "Found {count} projects to build" -PropertyValues $projects.count

foreach ($project in $projects)
{
    Write-InfoLog "Running build.ps1 with {count} projects to build" -PropertyValues (Resolve-Path $project.FullName -Relative)
    Write-InfoLog "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    & .\build\build.ps1 -project $project.FullName -version $version
    Write-InfoLog "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
}
