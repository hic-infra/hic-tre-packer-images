$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar


Set-Location C:\Tools

$LIBRE_VERSION = "7.5.4"
$LIBRE_HASH    = "efca7b819427f709960437dc4f0c603d1a4f928493836781929f5472b376b864"

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




