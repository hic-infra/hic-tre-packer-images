$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar

Set-Location C:\Tools

$7ZIP_VERSION = "2201"
$7ZIP_HASH    = "f4afba646166999d6090b5beddde546450262dc595dddeb62132da70f70d14ca"

$7ZIP_URL = "https://www.7-zip.org/a/7z${7ZIP_VERSION}-x64.msi"

Invoke-WebRequest -Uri ${7ZIP_URL} -OutFile 7zip.msi
$hash = Get-FileHash -Path 7zip.msi -Algorithm SHA256

if ( ${7ZIP_HASH} -ne $hash.Hash ) {
    throw("Invalid 7Zip hash")
}

Start-Process msiexec.exe -ArgumentList `
  ("/i", "7zip.msi",
   "/quiet"
  ) -NoNewWindow -Wait -PassThru



