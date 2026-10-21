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
	$ErrorActionPreference='Stop'

	& $Path @ArgumentList
}
catch
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