$UserDataPath = 'C:\workdir\UserDataJsonConfig.json'

while (!(Test-Path $UserDataPath)) { Start-Sleep 10 }

$UserData = @(Get-Content -Path $UserDataPath | ConvertFrom-JSON)

if ($UserData.SPSSLicenseServer) {
    $CommuterConf = @"
[Commuter]
DaemonHost=$($UserData.SPSSLicenseServer)
Organization=IBM
CommuterMaxLife=0
[Product]
VersionMajor=28
VersionMinor=0
"@

    Set-Content -Path 'C:\Program Files\IBM\SPSS Statistics\commutelicense.ini' -Value $CommuterConf
}
