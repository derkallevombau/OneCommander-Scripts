#PWSH

Import-Module 'E:\Dokumente\VS Code\Projects\Scripts\OneCommander Scripts\Modules\OCTools.psm1'

$target=Get-Clipboard

if ($target -eq '')
{
	throw "Clipboard empty or no text. Don't copy the folders, copy as path ($(getOCShortcutDisplayString -Id CopyPath))."
}
elseif ($target.Count -gt 1 -or !(Test-Path $target -PathType Container))
{
	# Show what's in clipboard, but don't print a whole Word doc.
	$text=$target -join ' '
	if ($text.Length -gt 50) { $text=$text.Substring(0, 50) + ' [...]' }

	throw "'$text' is not a single directory path."
}

$linkName=Split-Path $target -Leaf
$link=Join-Path -Path $env:CURRENT_DIR -ChildPath $linkName

Write-Host "Creating junction $link => $target..."
New-Item -Path $link -Value $target -ItemType Junction