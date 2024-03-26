# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2launch-v2-install.html
Set-Location C:\Tools

$ProgressPreference = "SilentlyContinue" # PS progress bar is slow
$ErrorActionPreference = "Stop"

Invoke-WebRequest -Uri "https://s3.amazonaws.com/amazon-ec2launch-v2/windows/amd64/latest/AmazonEC2Launch.msi" -OutFile C:\Tools\AmazonEC2Launch.msi
msiexec /i AmazonEC2Launch.msi /quiet
