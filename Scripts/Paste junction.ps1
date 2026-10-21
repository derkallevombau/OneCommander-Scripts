#PWSH

Add-Type -AssemblyName PresentationCore

# The subexpression operator is crucial to turn a single-element StringCollection into a
# string (forces enumeration by running the call through pipeline semantics).
$target=$([System.Windows.Clipboard]::GetFileDropList())

if ($target.Count -ne 1 -or !(Test-Path $target -PathType Container))
{
	throw "Inappropriate clipboard content. Copy a single directory."
}

$linkName=Split-Path $target -Leaf
$link=Join-Path -Path $env:CURRENT_DIR -ChildPath $linkName

Write-Host "Creating junction $link => $target..."
New-Item -Path $link -Value $target -ItemType Junction