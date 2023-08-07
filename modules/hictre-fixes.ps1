# Create a desktop shortcut for remounting S3
$batchPath = "C:\mount_s3.bat"
New-Item $batchPath
Set-Content $batchPath @"
powershell.exe C:\fixs3.ps1
powershell.exe C:\workdir\start-rclone.ps1
"@

$fixerPath = "C:\fixs3.ps1"
New-Item $fixerPath
Set-Content $fixerPath @"
taskkill /IM rclone.exe /F

Get-ChildItem -Path D:\ -Depth 0 -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  `$d = `$_
  try {
    `$files = `$d.GetFiles()
  } catch {
    `$name = `$d.Name
    Remove-Item -Path "D:\`${name}" -Force
  }
}
"@

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Administrator\Desktop\Remount D Drive.lnk")
$Shortcut.TargetPath = $batchPath
$Shortcut.Save()
