# SQL Management Studio

Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

# The installer has to be named "SSMS-Setup-ENU.exe" or it WILL NOT WORK.
# Installation of SSMS seems to break something with WinRM, so we will instead
# provide a desktop shortcut to install it.
Invoke-WebRequest -Uri "https://aka.ms/ssmsfullsetup" -OutFile C:\Tools\SSMS-Setup-ENU.exe
Start-Process C:\Tools\SSMS-Setup-ENU.exe -ArgumentList "/q","/install","/norestart" -NoNewWindow -Wait -PassThru
