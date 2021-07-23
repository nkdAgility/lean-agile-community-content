Write-Output "========================================================"
Write-Output "========================================================"
Write-Output "Concatonating all markdown files: the big squish"

$startMarkdown = "start.md"
$mypath = Split-Path $MyInvocation.MyCommand.Path -Parent
$mypath
$startPath = Join-Path -Path $mypath -ChildPath $startMarkdown
$startPath

$output = Get-Content $startPath

$includeFormat = "include::" # include::sales/2016/results.csv[] | include::path[leveloffset=offset,lines=ranges,tag(s)=name(s),indent=depth,opts=optional]

# Find all Inlcudess
$listOfIncludes = $output | Select-String -Pattern $includeFormat

foreach ($include in $listOfIncludes) {
    $includePattern = "(?<tag>include::)(?<filePath>.*)\[(?<options>.*)\]"
    $include -match $includePattern
    #$Matches
    $IncludePath = Join-Path -Path $mypath -ChildPath $Matches['filePath']
    $Matches = $null
    $IncludePath
    $includeContent = Get-Content $IncludePath  -Raw

    $includeContentLinkPattern = "\[(?<title>.*)\]\((?!image)(?<link>.*)\)"
    $includeContent -match $includeContentLinkPattern
    foreach ($match in $Matches) {
       $includeContentReplace = [regex]::escape($match[0])
       $includeContentReplace
       $includeContentReplaceWith = [regex]::escape($match['title'])
       $includeContentReplaceWith
       $includeContent = $includeContent -replace $includeContentReplace, $includeContentReplaceWith
    }

    $include = $include -replace "\]", "\]"
    $include = $include -replace "\[", "\["
    $output = $output -replace  $include, $includeContent
}

$outputPath = Split-Path $mypath -Parent
$mdOutPath = Join-Path -Path $outputPath -ChildPath "APS Trainer Guide.md"
Set-Content $mdOutPath $output
Write-Output "Created " $mdOutPath

#https://pandoc.org/lua-filters.html#examples
#https://stackoverflow.com/questions/48169995/pandoc-how-to-link-to-a-section-in-another-markdown-file
#https://stackoverflow.com/questions/60008898/pandoc-separate-table-of-contents-for-each-section

pandoc $mdOutPath -s --toc --toc-depth=2 -V geometry:margin=1in -o (Join-Path -Path $outputPath -ChildPath "APS Trainer Guide.pdf")
pandoc $mdOutPath -s --highlight-style espresso -o (Join-Path -Path $outputPath -ChildPath "APS Trainer Guide.html")
pandoc $mdOutPath -o (Join-Path -Path $outputPath -ChildPath "APS Trainer Guide.epub")
pandoc -s $mdOutPath -o (Join-Path -Path $outputPath -ChildPath "APS Trainer Guide.docx")


#$output
