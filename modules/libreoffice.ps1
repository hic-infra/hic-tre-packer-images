$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar


Set-Location C:\Tools

$LIBRE_VERSION = "24.2.0"
$LIBRE_HASH    = "58dcf13d87ef1279f7229b69949b836b73ce5f039ddb54cdf091f8fea28cc9f2"

$LIBRE_URL = "https://mirrors.ukfast.co.uk/sites/documentfoundation.org/tdf/libreoffice/stable/${LIBRE_VERSION}/win/x86_64/LibreOffice_${LIBRE_VERSION}_Win_x86-64.msi"

Invoke-WebRequest -Uri ${LIBRE_URL} -OutFile LibreOffice.msi
$hash = Get-FileHash -Path LibreOffice.msi -Algorithm SHA256

if ( ${LIBRE_HASH} -ne $hash.Hash ) {
    throw("Invalid LibreOffice hash")
}

Start-Process msiexec.exe -ArgumentList `
  ("/i", "LibreOffice.msi",
   "/quiet"
  ) -NoNewWindow -Wait -PassThru




