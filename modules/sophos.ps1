# Sophos
# We have to sleep for a while because the network takes some time to start up (with the correct nameserver etc).
Invoke-WebRequest -Uri ${Env:SOPHOS_SETUP_EXE} -OutFile C:\SophosSetup.exe

if ("$Env:SOPHOS_MESSAGE_RELAY") {
  $SOPHOS_SETUP_ARGS="--messagerelays=${Env:SOPHOS_MESSAGE_RELAY} --proxyaddress=${Env:SOPHOS_MESSAGE_RELAY}"
  $GROUP_PREFIX="HIC - AWS - Cloud TRE"
} else {
  $SOPHOS_SETUP_ARGS=""
  $GROUP_PREFIX="HIC - AWS - Other"
}

Write-Output "`
Start-Sleep -Seconds 600 `
C:\SophosSetup.exe --quiet $SOPHOS_SETUP_ARGS --devicegroup='$GROUP_PREFIX\\${SOPHOS_GROUP}'" | `
  Out-File -FilePath C:\SophosSetup.ps1

Register-ScheduledJob -Name SophosSetup -FilePath C:\SophosSetup.ps1 `
  -ScheduledJobOption (New-ScheduledJobOption -DoNotAllowDemandStart) `
  -Trigger (New-JobTrigger -AtStartup)
