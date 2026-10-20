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