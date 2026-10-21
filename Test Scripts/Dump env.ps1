#PWSH

Import-Module 'E:\Dokumente\VS Code\Projects\Scripts\OneCommander Scripts\Modules\ConsoleTools.psm1'

Get-ChildItem Env: | Format-Table -AutoSize -Wrap -Expand Both

keepConsoleOpen