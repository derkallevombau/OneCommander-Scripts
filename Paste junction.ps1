#PWSH

$target=Get-Clipboard

if ($target -eq '')
{
	Write-Error "Clipboard empty! Don't copy the folders, copy as path (Ctrl-Shift-C)."
	exit 1
}
elseif ($target.Count -gt 1 -or !(Test-Path $target -PathType Container))
{
	Write-Error "'$target' is not a single directory path. Exiting."
	exit 1
}

$linkName=Split-Path $target -Leaf
$link=Join-Path -Path $env:CURRENT_DIR -ChildPath $linkName

Write-Host "Creating junction $link => $target..."
New-Item -Path $link -Value $target -ItemType Junction

# Propagate error from New-Item, if any.
exit $? ? 0 : 1