
Set-Location C:\Tools
$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

$MAMBAFORGE_VERSION = "23.11.0-0"
$MAMBAFORGE_HASH = "2c4aa30733d3a52be315c974320c8e35a1635b0aef0d03064732aec9bb86eb2c"

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
  ("/InstallationType=AllUsers",
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

$condarc = "C:\Users\Administrator\.condarc"
New-Item $condarc
Set-Content $condarc "channels:"
Add-Content $condarc "  - conda-forge"
Add-Content $condarc "channel_alias: http://conda.hic-tre.dundee.ac.uk"

conda deactivate
