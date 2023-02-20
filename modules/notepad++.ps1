
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$NPP_VERSION = "8.1.5"
$NPP_HASH    = "902fa542ec5a1757d7b538032c4497b6e091bcf7bc83744348d8bdc00c87bd71"

$NPP_URL =  "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v${NPP_VERSION}/npp.${NPP_VERSION}.Installer.exe"

Invoke-WebRequest -Uri ${NPP_URL} -OutFile npp.exe

$hash = Get-FileHash -Path npp.exe -Algorithm SHA256

if ( ${NPP_HASH} -ne $hash.Hash ) {
    throw("Invalid NotePad++ hash")
}

Start-Process C:\Tools\npp.exe -ArgumentList "/S" -NoNewWindow -Wait -PassThru
