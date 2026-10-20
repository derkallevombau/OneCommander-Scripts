#PWSH

function getUsageHint
{
	$f=Join-Path -Path $env:OC_SETTINGS_DIR -ChildPath Shortcuts.json
	$sc=Get-Content -Path $f | ConvertFrom-Json | select -ExpandProperty CopyPath

	# Use WPF to convert to string
	Add-Type -AssemblyName PresentationCore
	$scDisp=[System.Windows.Input.KeyGesture]::new($sc.Key, $sc.Modifiers).
		GetDisplayStringForCulture([cultureinfo]::CurrentCulture)

	"Don't copy the folders, copy as path ($scDisp)."
}

$target=Get-Clipboard

if ($target -eq '')
{
	Write-Error "Clipboard empty or no text. $(getUsageHint)"
	exit 1
}
elseif ($target.Count -gt 1 -or !(Test-Path $target -PathType Container))
{
	# Show what's in clipboard, but don't print a whole Word doc.
	$text=$target -join ' '
	if ($text.Length -gt 50) { $text=$text.Substring(0,50) + ' [...]' }

	Write-Error "'$text' is not a single directory path."
	exit 1
}

$linkName=Split-Path $target -Leaf
$link=Join-Path -Path $env:CURRENT_DIR -ChildPath $linkName

Write-Host "Creating junction $link => $target..."
New-Item -Path $link -Value $target -ItemType Junction

# Propagate error from New-Item, if any.
exit $? ? 0 : 1