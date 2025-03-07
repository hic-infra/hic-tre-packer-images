Set-Location C:\Tools

$ProgressPreference = "SilentlyContinue" # PS progress bar is slow
$ErrorActionPreference = "Stop"

# R environment
Invoke-WebRequest -Uri "https://cloud.r-project.org/bin/windows/base/R-4.4.3-win.exe" -OutFile C:\Tools\R-installer.exe
Start-Process C:\Tools\R-installer.exe -ArgumentList "/VERYSILENT","/NORESTART" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://download1.rstudio.org/electron/windows/RStudio-2024.04.2-764.exe" -OutFile C:\Tools\RStudio-installer.exe
Start-Process C:\Tools\RStudio-installer.exe -ArgumentList "/S" -NoNewWindow -Wait -PassThru

Invoke-WebRequest -Uri "https://cran.r-project.org/bin/windows/Rtools/rtools44/files/rtools44-6459-6401.exe" -OutFile C:\Tools\RTools.exe
Start-Process C:\Tools\RTools.exe -ArgumentList "/VERYSILENT" -NoNewWindow -Wait -PassThru

# Install some default packages
$pkgs = "tidyverse","odbc","dbi","qqman","metafor","tidyr","ggplot2",`
  "hmisc","data.table","dplyr","lubridate","survival","survminer"
foreach ($pkg in $pkgs) {
    & "C:\Program Files\R\R-4.4.3\bin\Rscript.exe" `
      -e "install.packages('$pkg', repos='http://cran.uk.r-project.org')"
}

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
Set-Content "C:\Program Files\R\R-4.4.3\etc\Rprofile.site" $RConfig
Set-Content "C:\Users\Administrator\Documents\.Renviron" "RSTUDIO_DISABLE_SECURE_DOWNLOAD_WARNING=1"
