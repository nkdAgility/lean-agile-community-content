Clear-Host
Set-Location $PSScriptRoot
. .\include-logging.ps1
Write-InfoLog "========================================================"
Write-InfoLog "========================================================"
Write-InfoLog "Build naked Agility Lean-Agile Content"
$repoRoot = Split-Path $PSScriptRoot -Parent
if ($repoRoot -eq $null)
{
    $repoRoot = "C:\Users\MartinHinshelwoodnkd\source\repos\lean-agile-devops-content"
}
Write-DebugLog "repoRoot: {repoRoot}" -PropertyValues $repoRoot
Write-DebugLog "PSScriptRoot: {PSScriptRoot}" -PropertyValues (Resolve-Path $PSScriptRoot -Relative)
Write-DebugLog "MyInvocation.MyCommand.Path: {MyInvocationMyCommandPath}" -PropertyValues (Resolve-Path $MyInvocation.MyCommand.Path -Relative)
$buildRoot = Join-Path -Path $repoRoot -ChildPath "build"
Write-DebugLog "buildRoot: {buildRoot}" -PropertyValues (Resolve-Path $buildRoot -Relative)
Set-Location $repoRoot
Write-DebugLog "Execution Location set to repoRoot"
Write-InfoLog "========================================================"

# Find all content.json

$projects = Get-ChildItem -Filter project.json -Recurse
Write-InfoLog "Found {count} projects to build" -PropertyValues $projects.count

foreach ($project in $projects)
{
    $projectpath = Split-Path $project -Parent
    $projectpathr = (Resolve-Path $projectpath -Relative)
    Write-InfoLog "=====BUILD PROJECT START {projectpathr}" -PropertyValues $projectpathr
    # Get json
    $projectinfo = Get-Content $project | Out-String | ConvertFrom-Json
    Write-InfoLog "{ProjectTitle}" -PropertyValues $projectinfo.title

    # Create compiled files
    $projectpathobj = Join-Path -Path $projectpath -ChildPath ".obj"
    if (!(Test-Path $projectpathobj))
    {
        New-Item -itemType Directory -Path $projectpathobj
    }
    Write-DebugLog "projectpathobj: {projectpathobj}" -PropertyValues (Resolve-Path $projectpathobj -Relative)
    Write-DebugLog "Process header.hex"
    $objHeaderHexPath = (Join-Path -Path $projectpathobj -ChildPath "header.hex") 
    $headertexcontent = Get-Content (Join-Path -Path $buildRoot -ChildPath "header.tex")
    $headertexcontent | Out-File -FilePath $objHeaderHexPath
    Write-DebugLog "header.hex: {objHeaderHexPath}" -PropertyValues (Resolve-Path $objHeaderHexPath -Relative)
    Write-DebugLog "Process cover.hex"
    $objCoverHexPath = (Join-Path -Path $projectpathobj -ChildPath "cover.hex") 
    $covertexcontent = Get-Content (Join-Path -Path $buildRoot -ChildPath "cover.tex")
    $covertexcontent | Out-File -FilePath $objCoverHexPath
    Write-DebugLog "cover.hex: {objCoverHexPath}" -PropertyValues (Resolve-Path $objCoverHexPath -Relative)

    # Create compiled files
    $projectOutputPath = Join-Path -Path $projectpath -ChildPath "bin"
    if (!(Test-Path $projectOutputPath))
    {
        New-Item -itemType Directory -Path $projectOutputPath
    }
    Write-DebugLog "projectOutputPath: {projectOutputPath}" -PropertyValues (Resolve-Path $projectOutputPath -Relative)

    Write-DebugLog "Calling Pandoc" 
    Set-Location $projectpath

    & pandoc -f gfm -s --include-in-header $objHeaderHexPath --include-before-body $objCoverHexPath --toc --toc-depth=3 -V geometry:margin=1in -o (Join-Path -Path $projectOutputPath -ChildPath "$($projectinfo.title).pdf") $projectinfo.files
    Set-Location $repoRoot
    Write-InfoLog "=====BUILD PROJECT END {projectpathr}" -PropertyValues $projectpathr
}




#Remove-Item -path $mypath\ -Filter *text2pdf* -WhatIf

#$json = Get-Content "$mypath\configuration.json" | Out-String | ConvertFrom-Json

#https://dev.to/learnbyexample/customizing-pandoc-to-generate-beautiful-pdfs-from-markdown-3lbj
#https://pandoc.org/lua-filters.html#examples
#https://stackoverflow.com/questions/48169995/pandoc-how-to-link-to-a-section-in-another-markdown-file
#https://stackoverflow.com/questions/60008898/pandoc-separate-table-of-contents-for-each-section

#


# Don't forget to close the logger
Close-Logger