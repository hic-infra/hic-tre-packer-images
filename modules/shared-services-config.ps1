# Configure the workspace to access shared services

if (-not $env:SHARED_SERVICES_DOMAIN) {
  $env:SHARED_SERVICES_DOMAIN = "tre.internal"
}
if (-not $env:SHARED_SERVICES_DNS) {
  $env:SHARED_SERVICES_DNS = "10.253.0.253"
}

$condarc = @"
channels:
  - conda-forge
channel_alias: http://conda.${env:SHARED_SERVICES_DOMAIN}/
"@
Set-Content -Path C:\Users\Administrator\.condarc $condarc

$RConfig = @"
# TRE CRAN repository
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.${env:SHARED_SERVICES_DOMAIN}/"
       options(repos=r)
})
"@
Get-ChildItem "C:\Program Files\R" -Directory | ForEach-Object {
    Add-Content "$($_.FullName)\etc\Rprofile.site" $RConfig
}

Add-DnsClientNrptRule -Namespace ".${env:SHARED_SERVICES_DOMAIN}" -NameServers $env:SHARED_SERVICES_DNS
