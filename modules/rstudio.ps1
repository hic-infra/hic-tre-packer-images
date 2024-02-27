Set-Location C:\Tools

$ProgressPreference = "SilentlyContinue" # PS progress bar is slow
$ErrorActionPreference = "Stop"

# R environment
Invoke-WebRequest -Uri "https://cloud.r-project.org/bin/windows/base/R-4.3.2-win.exe" -OutFile C:\Tools\R-installer.exe
Start-Process C:\Tools\R-installer.exe -ArgumentList "/VERYSILENT","/NORESTART" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://download1.rstudio.org/electron/windows/RStudio-2023.12.1-402.exe" -OutFile C:\Tools\RStudio-installer.exe
Start-Process C:\Tools\RStudio-installer.exe -ArgumentList "/S" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://cloud.r-project.org/bin/windows/Rtools/rtools43/files/rtools43-5958-5975.exe" -OutFile C:\Tools\RTools.exe
Start-Process C:\Tools\RTools.exe -ArgumentList "/VERYSILENT" -NoNewWindow -Wait -PassThru

$RConfig = @"
# Set the default help type
options(help_type="html")

# HIC TRE R Repository
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.hic-tre.dundee.ac.uk/"
       options(repos=r)
})

# Set timezone
Sys.setenv(TZ='Europe/London')
"@
Set-Content "C:\Program Files\R\R-4.3.2\etc\Rprofile.site" $RConfig
Set-Content "C:\Users\Administrator\Documents\.Renviron" "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1"
