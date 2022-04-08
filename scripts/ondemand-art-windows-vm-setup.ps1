Function Install-Application($Url, $flags) {
    $LocalTempDir = $env:TEMP
    $Installer = "Installer.exe"
    (new-object  System.Net.WebClient).DownloadFile($Url, "$LocalTempDir\$Installer")
    & "$LocalTempDir\$Installer" $flags
    $Process2Monitor = "Installer"
    Do {
        $ProcessesFound = Get-Process | ? { $Process2Monitor -contains $_.Name } | Select-Object -ExpandProperty Name
        If ($ProcessesFound) { Write-Host "." -NoNewline -ForegroundColor Yellow; Start-Sleep -Seconds 2 } 
        else { Write-Host "Done" -ForegroundColor Cyan; rm "$LocalTempDir\$Installer" -ErrorAction SilentlyContinue }
    } 
    Until (!$ProcessesFound)
}

if (-not (Test-Path C:\Users\art)) {
    # add art user
    Write-Host "Adding 'art' user" -ForegroundColor Cyan
    $password = ConvertTo-SecureString "AtomicRedTeam1!" -AsPlainText -Force
    New-LocalUser "art" -Password $password -ErrorAction Ignore
    Add-LocalGroupMember -Group "Administrators" -Member "art" -ErrorAction Ignore
    Read-Host -Prompt "Switch users to the 'art' user then this script again. OK?" 
    exit
}

# install Chrome (must be admin)
$property = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe' -ErrorAction Ignore
if ( -not ($property -and $property.'(Default)')) {
    Write-Host "Installing Chrome" -ForegroundColor Cyan
    $flags = '/silent', '/install'
    Install-Application 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe' $flags
}

# Installing Chrome Bookmarks
Write-Host "Installing Chrome Bookmarks" -ForegroundColor Cyan
New-Item -ItemType "directory" -Path "C:\Users\art\AppData\Local\Google\Chrome\User Data\Default" -ErrorAction Ignore
Invoke-WebRequest "https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/Bookmarks" -OutFile "C:\Users\art\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"

# install Notepad++
if (-not (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*  | where-Object DisplayName -like 'NotePad++*')) {
    Write-Host "Installing Notepad++" -ForegroundColor Cyan
    Install-Application 'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.3.3/npp.8.3.3.Installer.x64.exe' '/S'
}

# add Desktop shortcuts
Write-Host "Creating Desktop Shortcuts" -ForegroundColor Cyan
Copy-Item 'C:\Users\art\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk' "C:\Users\art\Desktop\PowerShell.lnk"
Copy-Item 'C:\Users\art\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk' "C:\Users\art\Desktop\Command Prompt.lnk"
Copy-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk' "C:\Users\art\Desktop\Notepad++.lnk"

# Turn off Windows Defender Automatic Sample Submission
Write-Host "Turning off Windows Defender Automatic Sample Submission" -ForegroundColor Cyan
PowerShell Set-MpPreference -SubmitSamplesConsent 2
