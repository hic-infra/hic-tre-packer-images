
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$PBI_HASH = "250e751657a0de99da2bf6e5c1332e0e6f563aa71c0a3a52478ba6253318b267"
$PBI_URL = "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"

Invoke-WebRequest -Uri ${PBI_URL} -OutFile PBIDesktopSetup_x64.exe
$hash = Get-FileHash -Path PBIDesktopSetup_x64.exe -Algorithm SHA256

if ( ${PBI_HASH} -ne $hash.Hash ) {
    throw("Invalid PowerBI Desktop hash")
}

Start-Process C:\Tools\PBIDesktopSetup_x64.exe -ArgumentList `
  ("/q", "-norestart",  "ACCEPT_EULA=1"
  ) -NoNewWindow -Wait -PassThru

