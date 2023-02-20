# Rapid7 Insight agent

# Stop if a Cmdlet fails (but not exes)
$ErrorActionPreference = "stop"

$INSTALLER_FILENAME = "agentInstaller-x86_64.msi"
$INSTALLER_LOGFILE = "insight_agent_install.log"
$INSTALLER_TOKEN = "rapid7_insight_token.txt"

Set-Location c:\Tools

$env:Path += ';C:\Program Files\Amazon\AWSCLIV2\'

& aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/rapid7/$INSTALLER_FILENAME .
if((test-path -path $INSTALLER_FILENAME) -eq $false) {
    throw ("Failed to download $INSTALLER_FILENAME")
}

$RAPID7_INSIGHT_TOKEN = & aws s3 cp s3://${Env:S3_PACKER_RESOURCES_PATH}/rapid7/$INSTALLER_TOKEN -
if($RAPID7_INSIGHT_TOKEN.length -ne 39) {
    throw ("Expected token of length 39, received", $RAPID7_INSIGHT_TOKEN.length)
}

Write-Output @"
cd C:\Tools

While ( Test-NetConnection -ComputerName ${Env:RAPID7_PROXY_HOST} -Port 3128 |
  ? { ! `$_.TcpTestSucceeded } ) {
      Start-Sleep -Seconds 10
  }

Start-Process msiexec.exe -ArgumentList ``
  ("/i",   "$INSTALLER_FILENAME",
   "/l*v", "$INSTALLER_LOGFILE",
   "/quiet",
   "CUSTOMTOKEN=$RAPID7_INSIGHT_TOKEN",
   "HTTPSPROXY=${Env:RAPID7_PROXY_HOST}:3128"
  ) -NoNewWindow -Wait -PassThru
"@ | Out-File -FilePath C:\Tools\InsightSetup.ps1

Register-ScheduledJob -Name InsightSetup -FilePath C:\Tools\InsightSetup.ps1 `
  -ScheduledJobOption (New-ScheduledJobOption -DoNotAllowDemandStart) `
  -Trigger (New-JobTrigger -AtStartup)
