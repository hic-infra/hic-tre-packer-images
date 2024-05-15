$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar


Set-Location C:\Tools

$LIBRE_VERSION = "24.2.3"
$LIBRE_HASH    = "12b988318452120d31a4c618bc6ac314ad3bf99157584d0c2bf6029801a4cf31"

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




