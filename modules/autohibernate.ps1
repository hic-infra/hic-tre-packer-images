powercfg /change hibernate-timeout-ac $Env:AUTOHIBERNATE_TIME

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut([Environment]::GetFolderPath("Desktop") + "\Hibernate.lnk")
$shortcut.TargetPath = "C:\Windows\System32\shutdown.exe"
$shortcut.Arguments = "/h"
$shortcut.Save()
