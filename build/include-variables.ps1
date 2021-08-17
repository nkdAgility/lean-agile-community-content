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