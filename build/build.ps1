param([Parameter(Mandatory=$true)] [string]$project, [Parameter(Mandatory=$true)] [string]$version)

Set-Location $PSScriptRoot
. .\include-logging.ps1
Write-InfoLog "========================================================"
Write-InfoLog "Build {project}  v{version}" -PropertyValues (Resolve-Path $project -Relative), $version
. .\include-variables.ps1
Write-InfoLog "========================================================"
 # Get json
 $projectinfo = Get-Content $project | Out-String | ConvertFrom-Json
Write-InfoLog "{ProjectTitle}" -PropertyValues $projectinfo.title
$projectpath = Split-Path $project -Parent

# Create Output folder
$projectOutputPath = Join-Path -Path $projectpath -ChildPath "bin"
if (!(Test-Path $projectOutputPath))
{
    New-Item -itemType Directory -Path $projectOutputPath
} else {
    Remove-Item $projectOutputPath\*.*
}
Write-DebugLog "projectOutputPath: {projectOutputPath}" -PropertyValues (Resolve-Path $projectOutputPath -Relative)
# Create compiled files
$projectpathobj = Join-Path -Path $projectpath -ChildPath ".obj"
if (!(Test-Path $projectpathobj))
{
    New-Item -itemType Directory -Path $projectpathobj
}
Write-DebugLog "projectpathobj: {projectpathobj}" -PropertyValues (Resolve-Path $projectpathobj -Relative)

if ($projectinfo.assets -ne $null)
{
    foreach ($asset in $projectinfo.assets) 
    {
        Copy-Item -Path $asset -Destination $projectOutputPath
    }
}

if ( $projectinfo.buildoption -eq "Markdown2PDF")
{
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
    
    Write-DebugLog "Calling Pandoc" 
    Set-Location $projectpath
    
    $FileSafeTitle = $projectinfo.title -replace " ", "-"
    & pandoc -f gfm -s --include-in-header $objHeaderHexPath --include-before-body $objCoverHexPath --toc --toc-depth=3 -V geometry:margin=1in -o (Join-Path -Path $projectOutputPath -ChildPath "$FileSafeTitle-v$version.pdf") $projectinfo.files
    Set-Location $repoRoot
    Write-InfoLog "=====BUILD PROJECT END {projectpathr}" -PropertyValues $projectpathr
    
    
    #Remove-Item -path $mypath\ -Filter *text2pdf* -WhatIf
    
    #$json = Get-Content "$mypath\configuration.json" | Out-String | ConvertFrom-Json
    
    #https://dev.to/learnbyexample/customizing-pandoc-to-generate-beautiful-pdfs-from-markdown-3lbj
    #https://pandoc.org/lua-filters.html#examples
    #https://stackoverflow.com/questions/48169995/pandoc-how-to-link-to-a-section-in-another-markdown-file
    #https://stackoverflow.com/questions/60008898/pandoc-separate-table-of-contents-for-each-section    

}

if ( $projectinfo.buildoption -eq "PowerPoint")
{
    #
}


