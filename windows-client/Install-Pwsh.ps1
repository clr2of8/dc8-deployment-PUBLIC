Invoke-WebRequest https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/PowerShell-7.0.3-win-x64.msi -OutFile pscore.msi
msiexec /package pscore.msi /quiet