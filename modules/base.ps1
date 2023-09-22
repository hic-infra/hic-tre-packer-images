# During longer builds, Windows updates might have time to start which
# causes issues during the sysprep. This took me 16 hours to figure
# out so let's just move on.
Stop-Service -Name "wuauserv"

# Fix Win Server 2019 Visual Style (hard to see window boarders)
Set-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\DWM' -Name ColorPrevalence -Value 1
