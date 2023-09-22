Set-Location C:\Tools

$ProgressPreference = "SilentlyContinue" # PS progress bar is slow

# R environment
Invoke-WebRequest -Uri "https://cloud.r-project.org/bin/windows/base/old/4.1.3/R-4.1.3-win.exe" -OutFile C:\Tools\R-installer.exe
Start-Process C:\Tools\R-installer.exe -ArgumentList "/VERYSILENT","/NORESTART" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://download1.rstudio.org/desktop/windows/RStudio-2022.02.1-461.exe" -OutFile C:\Tools\RStudio-installer.exe
Start-Process C:\Tools\RStudio-installer.exe -ArgumentList "/S" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://github.com/r-windows/rtools-installer/releases/download/2022-02-06/rtools40-x86_64.exe" -OutFile C:\Tools\RTools.exe
Start-Process C:\Tools\RTools.exe -ArgumentList "/VERYSILENT" -NoNewWindow -Wait -PassThru

if ("$Env:CRAN_SERVER") {
$RConfig = @"
# Set the default help type
options(help_type="html")

# HIC TRE R Repository
local({r <- getOption("repos")
       r["CRAN"] <- "$Env:CRAN_SERVER"
       options(repos=r)
})

# Set timezone
Sys.setenv(TZ='Europe/London')
"@
Set-Content "C:\Program Files\R\R-4.1.3\etc\Rprofile.site" $RConfig
Set-Content "C:\Users\Administrator\Documents\.Renviron" "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1"
}
