# Sophos
# We have to sleep for a while because the network takes some time to start up (with the correct nameserver etc).
Invoke-WebRequest -Uri ${Env:SOPHOS_SETUP_EXE} -OutFile C:\SophosSetup.exe
Write-Output "`
Start-Sleep -Seconds 600 `
C:\SophosSetup.exe --quiet --messagerelays=${Env:SOPHOS_MESSAGE_RELAY} --proxyaddress=${Env:SOPHOS_MESSAGE_RELAY} --devicegroup='HIC - AWS - Cloud TRE\\${SOPHOS_GROUP}'" | `
  Out-File -FilePath C:\SophosSetup.ps1

Register-ScheduledJob -Name SophosSetup -FilePath C:\SophosSetup.ps1 `
  -ScheduledJobOption (New-ScheduledJobOption -DoNotAllowDemandStart) `
  -Trigger (New-JobTrigger -AtStartup)
