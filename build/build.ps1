param([Parameter(Mandatory=$true)] [string]$project, [Parameter(Mandatory=$true)] [string]$version, [Parameter(Mandatory=$false)] [boolean]$rebuild = $false)

Set-Location $PSScriptRoot
. .\include-logging.ps1
Write-InfoLog "-----------------------------------------------------------"
Write-InfoLog "|- Build {project}  v{version}" -PropertyValues (Resolve-Path $project -Relative), $version
. .\include-variables.ps1

 # Get json
 $projectinfo = Get-Content $project | Out-String | ConvertFrom-Json
Write-InfoLog " |- {ProjectTitle}" -PropertyValues $projectinfo.title
$projectpath = Split-Path $project -Parent

# Create Output folder
Write-InfoLog " |- Manage BIN Folder"
$projectOutputPath = Join-Path -Path $projectpath -ChildPath "bin"
if (!(Test-Path $projectOutputPath))
{
    Write-DebugLog "  |- Creating BIN"
    New-Item -itemType Directory -Path $projectOutputPath
} else {
    if ($rebuild)
    {
        Write-DebugLog "  |- Cleaning BIN"
        Remove-Item $projectOutputPath\*.*
    }    
}
Write-DebugLog "  |- projectOutputPath: {projectOutputPath}" -PropertyValues (Resolve-Path $projectOutputPath -Relative)

# Create compiled files
Write-InfoLog " |-- Manage .obj Folder"
$projectpathobj = Join-Path -Path $projectpath -ChildPath ".obj"
if (!(Test-Path $projectpathobj))
{
    Write-DebugLog "  |- Creating .obj"
    New-Item -itemType Directory -Path $projectpathobj
} else {
    if ($rebuild)
    {
        Write-DebugLog "  |- Cleaning .obj"
        Remove-Item $projectOutputPath\*.*
    }    
}
Write-DebugLog "  |- projectpathobj: {projectpathobj}" -PropertyValues (Resolve-Path $projectpathobj -Relative)

#Add Assets
Write-InfoLog " |- Move assets to bin"
if ($projectinfo.assets -ne $null)
{
    foreach ($asset in $projectinfo.assets) 
    {
        Write-DebugLog "  |- Asset: {asset}" -PropertyValues $asset
        Copy-Item -Path $asset -Destination $projectOutputPath
    }
}

Write-InfoLog " |- Build {buildoption} " -PropertyValues $projectinfo.buildoption
if ( $projectinfo.buildoption -eq "Markdown2PDF")
{
    Write-InfoLog "  |- Process header.hex"
    $objHeaderHexPath = (Join-Path -Path $projectpathobj -ChildPath "header.hex") 
    $headertexcontent = Get-Content (Join-Path -Path $buildRoot -ChildPath "header.tex")
    $headertexcontent | Out-File -FilePath $objHeaderHexPath
    Write-DebugLog "   |- header.hex: {objHeaderHexPath}" -PropertyValues (Resolve-Path $objHeaderHexPath -Relative)
    Write-InfoLog "  |- Process cover.hex"
    $objCoverHexPath = (Join-Path -Path $projectpathobj -ChildPath "cover.hex") 
    $covertexcontent = Get-Content (Join-Path -Path $buildRoot -ChildPath "cover.tex")
    $covertexcontent | Out-File -FilePath $objCoverHexPath
    Write-DebugLog "   |- cover.hex: {objCoverHexPath}" -PropertyValues (Resolve-Path $objCoverHexPath -Relative)
    
    Write-InfoLog " |- Calling Pandoc" 
    Set-Location $projectpath
    
    $FileSafeTitle = $projectinfo.title -replace " ", "-";
    $outputFileName = "$FileSafeTitle-v$version.pdf";
    $outputFilePath = (Join-Path -Path $projectOutputPath -ChildPath $outputFileName)
    Write-DebugLog "  |- & pandoc -f gfm -s --include-in-header $objHeaderHexPath --include-before-body $objCoverHexPath --toc --toc-depth=3 -V geometry:margin=1in -o $outputFilePath $($projectinfo.files)"
    if ($rebuild -and (!Test-Path($outputFilePath)))
    {
        & pandoc -f gfm -s --include-in-header $objHeaderHexPath --include-before-body $objCoverHexPath --toc --toc-depth=3 -V geometry:margin=1in -o $outputFilePath $projectinfo.files
    }

    
    Set-Location $repoRoot

    $bindir = Get-ChildItem -Path $projectOutputPath
    Write-InfoLog " |- Bin now contains {ProjectTitle}" -PropertyValues $bindir.count;
    foreach ($item in $bindir)
    {
        Write-InfoLog "  |- Item: {Item}" -PropertyValues $item.Name;
    }

    Write-InfoLog " |- BUILD PROJECT END {projectpathr}" -PropertyValues (Resolve-Path $project -Relative)
    
    
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


