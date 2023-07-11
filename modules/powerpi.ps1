
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$PBI_HASH = "511e86ab13e204a00b73301e70deb40e323f6c809277b8200df7160ea2a1bc4b"
$PBI_URL = "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"

Invoke-WebRequest -Uri ${PBI_URL} -OutFile PBIDesktopSetup_x64.exe
$hash = Get-FileHash -Path PBIDesktopSetup_x64.exe -Algorithm SHA256

if ( ${PBI_HASH} -ne $hash.Hash ) {
    throw("Invalid PowerBI Desktop hash")
}

Start-Process C:\Tools\PBIDesktopSetup_x64.exe -ArgumentList `
  ("/q", "-norestart",  "ACCEPT_EULA=1"
  ) -NoNewWindow -Wait -PassThru

