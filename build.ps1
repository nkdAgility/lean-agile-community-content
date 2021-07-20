Write-Output "========================================================"
Write-Output "========================================================"
Write-Output "Concatonating all markdown files: the big squish"



$mypath = Split-Path $MyInvocation.MyCommand.Path -Parent
if ($mypath -eq $null)
{
    $mypath = "C:\Users\MartinHinshelwoodnkd\source\repos\lean-agile-devops-content"
}
$mypath

#Remove-Item -path $mypath\ -Filter *text2pdf* -WhatIf

$json = Get-Content "$mypath\configuration.json" | Out-String | ConvertFrom-Json

#https://dev.to/learnbyexample/customizing-pandoc-to-generate-beautiful-pdfs-from-markdown-3lbj
#https://pandoc.org/lua-filters.html#examples
#https://stackoverflow.com/questions/48169995/pandoc-how-to-link-to-a-section-in-another-markdown-file
#https://stackoverflow.com/questions/60008898/pandoc-separate-table-of-contents-for-each-section

& pandoc $mdOutPath -f gfm -s --include-in-header header.tex --include-before-body cover.tex --toc --toc-depth=3 -V geometry:margin=1in -o (Join-Path -Path $mypath -ChildPath "$($json.title).pdf") $json.files

