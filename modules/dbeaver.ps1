Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$DBEAVER_URL = "https://github.com/dbeaver/dbeaver/releases/download/22.3.3/dbeaver-ce-22.3.3-x86_64-setup.exe"
Invoke-WebRequest -Uri ${DBEAVER_URL} -OutFile dbeaver-ce.exe

Start-Process .\dbeaver-ce.exe -ArgumentList "/allusers","/S" -NoNewWindow -Wait -PassThru
