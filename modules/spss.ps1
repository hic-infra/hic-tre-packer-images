
Set-Location C:\Tools

aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/Statistics_28_Win_64bit.exe Statistics_28_Win_64bit.exe

Start-Process Statistics_28_Win_64bit.exe -Wait -ArgumentList '/S','/v/qn','/V','/i'

Register-ScheduledJob -Name SPSSLicenseUpdate -FilePath C:\Tools\ActivateSPSS.ps1 `
  -ScheduledJobOption (New-ScheduledJobOption -DoNotAllowDemandStart) `
  -Trigger (New-JobTrigger -AtStartup)
