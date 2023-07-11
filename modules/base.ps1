# During longer builds, Windows updates might have time to start which
# causes issues during the sysprep. This took me 16 hours to figure
# out so let's just move on.
Stop-Service -Name "wuauserv"

# Fix Win Server 2019 Visual Style (hard to see window boarders)
Set-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\DWM' -Name ColorPrevalence -Value 1

# Create a desktop shortcut for remounting S3
$batchPath = "C:\mount_s3.bat"
New-Item $batchPath
Set-Content $batchPath @"
powershell.exe C:\workdir\start-rclone.ps1
"@
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Administrator\Desktop\Remount D Drive.lnk")
$Shortcut.TargetPath = $batchPath
$Shortcut.Save()
