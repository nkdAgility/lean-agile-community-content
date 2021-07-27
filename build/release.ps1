Clear-Host
Set-Location $PSScriptRoot

. .\include-logging.ps1

Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "Release naked Agility Lean-Agile Content"
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"

. .\include-modules.ps1
RequiredModule PowerShellForGitHub
RequiredModule PoShLog


#. .\build.ps1

$repoRoot = Split-Path $PSScriptRoot -Parent
if ($repoRoot -eq $null)
{
    $repoRoot = "C:\Users\MartinHinshelwoodnkd\source\repos\lean-agile-devops-content"
}
Set-Location $repoRoot

$version = gitversion.exe | ConvertFrom-Json

$soureFolder = Join-Path -Path $repoRoot -ChildPath "source"

# Create compiled files
$releaseOutputPath = Join-Path -Path $repoRoot -ChildPath "staging"
if (!(Test-Path $releaseOutputPath))
{
    New-Item -itemType Directory -Path $releaseOutputPath
}
Write-DebugLog "releaseOutputPath: {releaseOutputPath}" -PropertyValues (Resolve-Path $releaseOutputPath -Relative)

$binFoldersFound = Get-Childitem -Path $soureFolder -Recurse -Filter bin -Directory
Write-InfoLog "Found {count} bin folders to process" -PropertyValues $binFoldersFound.count
Foreach ($binFolder in $binFoldersFound)
{
    Write-InfoLog "bin: {binfFolder}" -PropertyValues $binFolder

    Get-ChildItem $binFolder -Recurse | `
    Where-Object { $_.PSIsContainer -eq $False } | `
    ForEach-Object {Copy-Item -Path $_.Fullname -Destination $releaseOutputPath -Force}

    #Copy-Item -Filter *.* -Path $binFolder -Recurse -Destination $releaseOutputPath
}

$releaseversion = $version.SemVer

Write-InfoLog "Version number is: {FullSemVer}" -PropertyValues $releaseversion
# Create Release
$release = Get-GitHubRelease -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" | Where-Object {$_.tag_name -eq $releaseversion}
if ($release -eq $null)
{
    Write-InfoLog "Creating New Release: {releaseversion}" -PropertyValues $releaseversion
    $release = New-GitHubRelease -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Tag $releaseversion
}
Write-InfoLog "Release: {releaseversion}" -PropertyValues $release.id

[String[]] $ReleaseAssets = Get-GitHubReleaseAsset -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Release $release.id | Select-Object -ExpandProperty Name -Unique
Write-InfoLog "Release Assets: {ReleaseAssetsCount}" -PropertyValues $ReleaseAssets.count
$localAssets = Get-ChildItem -Path $releaseOutputPath
Write-InfoLog "Local Assets: {localAssetsCount}" -PropertyValues $localAssets.count
foreach($localAssrt in $localAssets)
{
    if ($ReleaseAssets.Contains($localAssrt.Name))
    {
        Write-InfoLog "Uploadign Asset: {localAssrtName}" -PropertyValues $localAssrt.Name
        $ReleaseAsset = New-GitHubReleaseAsset -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Release $release.id -Path $localAssrt.FullName
    
    } else {
        Write-InfoLog "Asset Exists: {localAssrtName}" -PropertyValues $localAssrt.Name
    }
    
}



# Don't forget to close the logger
Close-Logger