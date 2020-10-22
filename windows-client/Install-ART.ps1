Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
Add-MpPreference -ExclusionPath C:\AtomicRedTeam\
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force
New-Item -ItemType Directory (split-path $profile) -Force
Set-Content $profile 'Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force'