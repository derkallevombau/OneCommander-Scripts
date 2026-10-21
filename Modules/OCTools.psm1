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
	Returns an array of paths of files/folders copied to clipboard.
.LINK
	https://learn.microsoft.com/en-us/dotnet/api/system.windows.clipboard.getfiledroplist?view=windowsdesktop-10.0
#>
function getClipbrdFiles
{
	# The Clipboard class used here is part of WPF.
	Add-Type -AssemblyName PresentationCore

	# Caution! This method returns a StringCollection.
	# When written to success stream, it is enumerated.
	# `$f=getClipbrdFiles` receives the individual string(s), the StringCollection has
	# evaporated.
	# A single string stays as is, multiple ones are put into an array, and an empty
	# StringCollection (if clipboard contains no files) yields $null because nothing is
	# written to the stream.
	# Using `$f=[System.Windows.Clipboard]::GetFileDropList()` directly is different:
	# Even for a single string, it's still a StringCollection; using it like a string
	# can give strange results like the type name via ToString().
	# Wrapping the RHS in $(...) solves that issue - it runs the call through pipeline
	# semantics, forcing enumeration.
	[System.Windows.Clipboard]::GetFileDropList()
}