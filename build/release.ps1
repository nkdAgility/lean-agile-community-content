Clear-Host
Set-Location $PSScriptRoot

. .\include-logging.ps1
. .\include-modules.ps1
RequiredModule PowerShellForGitHub
RequiredModule PoShLog

Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "Release naked Agility Lean-Agile Content"
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"


$repoRoot = Split-Path $PSScriptRoot -Parent
if ($repoRoot -eq $null)
{
    $repoRoot = "C:\Users\MartinHinshelwoodnkd\source\repos\lean-agile-devops-content"
}
Set-Location $repoRoot

$gitversion = gitversion.exe | ConvertFrom-Json
$version = "0.1.0" #$version.SemVer
Write-DebugLog "Version: {version}" -PropertyValues $version;


& git fetch


& .\build\build-all.ps1 -version $version


$soureFolder = Join-Path -Path $repoRoot -ChildPath "source"

# Create compiled files
$releaseOutputPath = Join-Path -Path $repoRoot -ChildPath "staging"
if (!(Test-Path $releaseOutputPath))
{
    New-Item -itemType Directory -Path $releaseOutputPath
} else {
    Remove-Item $releaseOutputPath\*.*
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

$releaseversion = "v$version"

Write-InfoLog "Version number is: {FullSemVer}" -PropertyValues $releaseversion
# Create Release
$release = Get-GitHubRelease -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" | Where-Object {$_.tag_name -eq $releaseversion}
if ($release -eq $null)
{
    Write-InfoLog "Creating New Release: {releaseversion}" -PropertyValues $releaseversion
    $release = New-GitHubRelease -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Tag $releaseversion
}
Write-InfoLog "Release: {releaseversion}" -PropertyValues $release.id

$ReleaseAssets = Get-GitHubReleaseAsset -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Release $release.id

Write-InfoLog "Release Assets: {ReleaseAssetsCount}" -PropertyValues $ReleaseAssets.count
#Write-InfoLog "Release Assets: {@ReleaseAssets}" -PropertyValues $ReleaseAssets 
$localAssets = Get-ChildItem -Path $releaseOutputPath
Write-InfoLog "Local Assets: {localAssetsCount}" -PropertyValues $localAssets.count
foreach($localAssrt in $localAssets)
{
    $ReleaseAsset = $ReleaseAssets | Where-Object {$_.name -eq $localAssrt.Name}
    Write-InfoLog "Release Asset: {ReleaseAsset}" -PropertyValues $ReleaseAsset.id
    
    if ($ReleaseAsset -eq $null)
    {
        Write-InfoLog "Uploading  Asset: {localAssrtName}" -PropertyValues $localAssrt.Name
        $ReleaseAsset = New-GitHubReleaseAsset -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Release $release.id -Path $localAssrt.FullName
    
    } else {
        Write-InfoLog "Existing Asset: {localAssrtName}" -PropertyValues $localAssrt.Name
        #Set-GitHubReleaseAsset -OwnerName "nkdAgility" -RepositoryName "lean-agile-devops-content" -Asset $ReleaseAsset.id -Path $localAssrt.FullName   
    }
    
}

# Don't forget to close the logger
Close-Logger