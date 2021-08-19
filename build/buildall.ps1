param([Parameter(Mandatory=$false)] [string]$version)
Clear-Host;
if (($version -eq $null) -or ($version -eq ""))
{
    $version = "0.0.0"
}

Set-Location $PSScriptRoot
. .\include-logging.ps1
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "Build ALL v{version}" -PropertyValues $version
. .\include-variables.ps1
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
# Find all content.json
$projects = Get-ChildItem -Filter project.json -Recurse
Write-InfoLog "Found {count} projects to build" -PropertyValues $projects.count
Write-InfoLog "========================================================"
Write-InfoLog "********************************************************"

foreach ($project in $projects)
{
    Write-InfoLog "********************************************************"
    Write-InfoLog "Running build.ps1 with {count} projects to build" -PropertyValues (Resolve-Path $project.FullName -Relative)
    
    & .\build\build.ps1 -project $project.FullName -version $version -rebuild $false
    Write-InfoLog "********************************************************"
    
}
Write-InfoLog "********************************************************"
Write-InfoLog "Completed build of {count} projects" -PropertyValues $projects.count
Write-InfoLog "********************************************************"

# Create Output folder
Write-InfoLog "|- Manage Global BIN Folder"
$OutputPath = Join-Path -Path $repoRoot -ChildPath "bin"
if (!(Test-Path $OutputPath))
{
    Write-DebugLog " |- Creating BIN"
    New-Item -itemType Directory -Path $OutputPath
} else {
    if ($rebuild)
    {
        Write-DebugLog " |- Cleaning BIN"
        Remove-Item $OutputPath\*.*
    }    
}
Write-DebugLog "  |- OutputPath: {OutputPath}" -PropertyValues (Resolve-Path $OutputPath -Relative)


$outputfiles = Get-ChildItem -path (Join-Path -Path $repoRoot -ChildPath "source") -recurse ($source) -File | Where-Object {$_.PSParentPath -match "bin"}
Write-InfoLog "|- Found {count} output files" -PropertyValues $outputfiles.count;
foreach ($outfile in $outputfiles)
{
    Write-InfoLog " |- Moving {file} to bin" -PropertyValues $outfile.Name
    Copy-Item $outfile -Destination $OutputPath
}
Write-InfoLog "********************************************************"
Write-InfoLog "Completed"
Write-InfoLog "********************************************************"