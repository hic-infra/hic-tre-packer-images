
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$MAMBAFORGE_VERSION = "22.11.1-2"
$MAMBAFORGE_HASH = "3dfdaf08d86acdbf9c0b1f390719a0c671483dd327f3f594355504d7bce18402"

$MAMBAFORGE_URL = "https://github.com/conda-forge/miniforge/releases/download/${MAMBAFORGE_VERSION}/Mambaforge-${MAMBAFORGE_VERSION}-Windows-x86_64.exe"

Invoke-WebRequest -Uri ${MAMBAFORGE_URL} -OutFile Mambaforge.exe
$hash = Get-FileHash -Path Mambaforge.exe -Algorithm SHA256

if ( ${MAMBAFORGE_HASH} -ne $hash.Hash ) {
    throw("Invalid Mambaforge hash")
}

# This is installed to the root of the C:\ drive rather than the
# user's home directory. The first boot after sysprep copies the
# Administrator's directory to Default, and then back to
# Administrator. Not sure why, but since conda contains many thousands
# of files, this can take 30+ minutes, causing the CloudFormation
# template to timeout.
Start-Process C:\Tools\Mambaforge.exe -ArgumentList `
  ("/InstallationType=JustMe",
   "/RegisterPython=1",
   "/S",
   "/D=C:\conda"
  ) -NoNewWindow -Wait -PassThru

(& "C:\conda\Scripts\conda.exe" "shell.powershell" "hook") | `
  Out-File CondaActivate.ps1
& .\CondaActivate.ps1

$BASE_ENVIRONMENT_YML = "C:\Tools\conda-environment.yml"
if ( Test-Path -Path ${BASE_ENVIRONMENT_YML} -PathType Leaf ) {
    Write-Output "Conda: Configuring shell and installing packages"
    mamba init
    mamba env update --file "$BASE_ENVIRONMENT_YML"
} else {
    Write-Output "$BASE_ENVIRONMENT_YML not found, skipping"
}

conda deactivate
