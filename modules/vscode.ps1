
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$VSCODE_SHA256 = "f4cd3b2d845bd2a61152707c2b8626c10e8e9bcd1a8163944c34635172f6cdd9"
$VSCODE_URL = "https://az764295.vo.msecnd.net/stable/74b1f979648cc44d385a2286793c226e611f59e7/VSCodeUserSetup-x64-1.71.2.exe"

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
