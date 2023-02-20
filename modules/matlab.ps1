# Matlab requires about 32GB of disk space, but also 32GB during the
# setup because we can't extract from stdin.

$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar

Set-Location C:\Tools

$src = "s3://${Env:S3_PACKER_RESOURCES_PATH}/matlab_installed_r2021b.zip"

aws s3 cp $src matlab.zip

$7ZIP_PATH = "C:\Program Files\7-Zip\7z.exe"
$7ZIP = Test-Path -Path $7ZIP_PATH
if ($7ZIP -eq $True) {
    # 7zip does support extracting from stdin but AWS CLI will allocate all the memory...
    & $7ZIP_PATH x matlab.zip -r -y -o"C:\Program Files\"
} else {
    # Slow
    Expand-Archive -Path matlab.zip -DestinationPath "C:\Program Files\"
}
Remove-Item -Path matlab.zip

# Create desktop and Start Menu shortcuts
$WShell = New-Object -comObject WScript.Shell
$shortcut = $WShell.CreateShortcut("$HOME\Desktop\MATLAB R2021b.lnk")
$shortcut.TargetPath = "C:\Program Files\MATLAB\R2021b\bin\matlab.exe"
$shortcut.Save()

$shortcut = $WShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\MATLAB R2021b.lnk")
$shortcut.TargetPath = "C:\Program Files\MATLAB\R2021b\bin\matlab.exe"
$shortcut.Save()

