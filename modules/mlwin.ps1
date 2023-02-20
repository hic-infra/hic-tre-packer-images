
Set-Location C:\Tools

aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/MLwiN.msi MLwiN.msi

Start-Process msiexec.exe -Wait -ArgumentList '/I MLwiN.msi /quiet'
