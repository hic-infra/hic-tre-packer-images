Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-GB" -OutFile FirefoxSetup.msi
Start-Process msiexec.exe -ArgumentList "/i","FirefoxSetup.msi","/passive" -NoNewWindow -Wait -PassThru
