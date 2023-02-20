# Stop if a Cmdlet fails (but not exes)
$ErrorActionPreference = "stop"

Start-Process msiexec.exe -ArgumentList "/i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet" -NoNewWindow -Wait -PassThru
