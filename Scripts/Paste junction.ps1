#PWSH

Import-Module 'E:\Dokumente\VS Code\Projects\Scripts\OneCommander Scripts\Modules\OCTools.psm1'

$target=getClipbrdFiles

if ($target.Count -ne 1 -or !(Test-Path $target -PathType Container))
{
	throw "Inappropriate clipboard content. Copy a single directory."
}

$linkName=Split-Path $target -Leaf
$link=Join-Path -Path $env:CURRENT_DIR -ChildPath $linkName

Write-Host "Creating junction $link => $target..."
New-Item -Path $link -Value $target -ItemType Junction