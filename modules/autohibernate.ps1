
$ramGB = (Get-CimInstance Win32_PhysicalMemory).Capacity / 1024 / 1024 / 1024

if ($null -eq $Env:AUTOHIBERNATE_TIME) {
    $Env:AUTOHIBERNATE_TIME = 120
}

# Windows cannot hibernate (at least in AWS) if it has more than 16GB
# of RAM. Instead we'll forcefully shutdown the instance because EC2
# is expensive!
if ($ramGB -gt 16) {
    $idleScript = "C:\workdir\idleshutdown.ps1"
    New-Item $idleScript
    Set-Content $idleScript @"
`$quser = quser | ForEach-Object -Process { `$_ -replace '\s{2,21}',',' } | ConvertFrom-Csv
`$session = `$quser | Where-Object {{ `$_.SessionName -like "rdp-tcp*" -or `$_.State -eq "Disc" }}

# quser time is in the following formats, depending on duration.
# "days+hours:minutes" or "hours:minutes" or "minutes" or, if
# less than a minute "."
# We need to convert it to something we can cast to TimeSpan,
# i.e. "days.hours:minutes" or just "hours:minutes"
`$idleTime = (`$session.'IDLE TIME').Replace('+', '.')
if (`$idleTime -eq ".") { `$idleTime = 0 }
if (`$idleTime -notmatch "\.") { `$idleTime = "0.0:`$idleTime" }
`$idleTime = [TimeSpan]`$idleTime

if (`$idleTime.TotalMinutes -ge $Env:AUTOHIBERNATE_TIME) {
  Stop-Computer -ComputerName localhost -Force
}
"@

    $action = New-ScheduledTaskAction -Execute powershell.exe `
      -Argument "-File $idleScript"
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
      -RepetitionInterval (New-TimeSpan -Minutes 1) `
      -RepetitionDuration (New-TimeSpan -Days 3650)
    $principal = New-ScheduledTaskPrincipal `
      -UserID "NT AUTHORITY\SYSTEM" `
      -LogonType ServiceAccount

    Register-ScheduledTask "ShutdownIdle" `
      -Action $action `
      -Principal $principal `
      -Trigger $trigger `
      -Force
} else {
    powercfg /change hibernate-timeout-ac $Env:AUTOHIBERNATE_TIME

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut([Environment]::GetFolderPath("Desktop") + "\Hibernate.lnk")
    $shortcut.TargetPath = "C:\Windows\System32\shutdown.exe"
    $shortcut.Arguments = "/h"
    $shortcut.Save()
}
