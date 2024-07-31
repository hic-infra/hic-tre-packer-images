$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar


Set-Location C:\Tools

$LIBRE_VERSION = "24.2.5"
$LIBRE_HASH    = "cad625d119db4720df5270fa2d860e0ed56d6e374b878e19a3cab4af68f1f54f"

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




