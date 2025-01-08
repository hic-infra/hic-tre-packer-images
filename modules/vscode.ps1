
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$VSCODE_SHA256 = "7ce997d7a80ff838c2b7312be6e26917a8b66a67c633ee0b3317b1ae70010077"
$VSCODE_URL = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/VSCodeUserSetup-x64-1.95.3.exe"

Invoke-WebRequest -Uri ${VSCODE_URL} -OutFile C:\Tools\vscode.exe

$hash = Get-FileHash -Path C:\Tools\vscode.exe -Algorithm SHA256

if ( ${VSCODE_SHA256} -ne $hash.Hash ) {
    throw("Invalid VSCode hash")
}

Start-Process C:\Tools\vscode.exe -ArgumentList `
  ("/VERYSILENT",
   "/NORESTART",
   "/MERGETASKS=!runcode"
  ) -NoNewWindow -Wait -PassThru


# Install extensions
$EXTENSIONS = (
  "ms-python.python",
  "ms-toolsai.jupyter",
  "ms-vscode.PowerShell"
)
$CODE = "$HOME\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
foreach ($ext in $EXTENSIONS)
{
  Start-Process $CODE -ArgumentList ("--install-extension", $ext) -NoNewWindow -Wait -PassThru
}
Start-Process $CODE -ArgumentList ("--list-extensions") -NoNewWindow -Wait -PassThru
