# To run scripts from OneCommander without -NoExit

param(
	[Parameter(Mandatory, Position = 0)]
	[string]$Path,
	[Parameter(Position = 1, ValueFromRemainingArguments)]
	[PSObject[]]$ArgumentList
)

function block
{
	Write-Host -NoNewline "`nPress <Enter> to exit."
	Read-Host
}

try
{
	# Turn non-terminating errors into terminating ones (see
	# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_error_handling#the-erroractionpreference-variable).
	# Applies to child scopes. Thus, we don't need `exit $? ? 0 : 1` in actual script.
	$ErrorActionPreference='Stop'

	& $Path @ArgumentList

	if (! $?) # Non-terminating error
	{
		block
	}
}
catch # Script-terminating error
{
	if ($_.TargetObject -eq $_.FullyQualifiedErrorId) # throw <string>
	{
		# Just the <string>. We don't want the underlined throw statement.
		$_.TargetObject
	}
	else
	{
		$_
	}

	block
}