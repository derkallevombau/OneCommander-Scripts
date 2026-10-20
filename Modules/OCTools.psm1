function getOCShortcutDisplayString
{
	param(
		[Parameter(Mandatory, Position = 0, HelpMessage = '
			One of the keys of the object in Shortcuts.json ("NewFolder", "NewFile" etc.).
		')]
		[string]$Id
	)

	$f=Join-Path -Path $env:OC_SETTINGS_DIR -ChildPath Shortcuts.json
	$sc=Get-Content -Path $f | ConvertFrom-Json | select -ExpandProperty $Id

	# Use WPF to convert to string
	Add-Type -AssemblyName PresentationCore
	$scDisp=[System.Windows.Input.KeyGesture]::new($sc.Key, $sc.Modifiers).
		GetDisplayStringForCulture([cultureinfo]::CurrentCulture)

	$scDisp
}

<#
.SYNOPSIS
	Returns a collection of paths of files/folders copied to clipboard.
.LINK
	https://learn.microsoft.com/en-us/dotnet/api/system.windows.clipboard.getfiledroplist?view=windowsdesktop-10.0
#>
function getClipbrdFiles
{
	# The Clipboard class used here is part of WPF.
	Add-Type -AssemblyName PresentationCore

	[System.Windows.Clipboard]::GetFileDropList()
}