$ProgressPreference = 'SilentlyContinue' # Disable (slow) progress bar

Set-Location C:\Tools

$OPENJDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9.1/OpenJDK17U-jdk_x64_windows_hotspot_17.0.9_9.msi"
$OPENJDK_HASH="cd7b319f6fbd7efc68a0e464c55c7f2a28d6b8be3d0bcda315a16f885c57cadb"

Invoke-WebRequest -Uri ${OPENJDK_URL} -OutFile OpenJDK17.msi
$hash = Get-FileHash -Path OpenJDK17.msi -Algorithm SHA256

if ( ${OPENJDK_HASH} -ne $hash.Hash ) {
    throw("Invalid OpenJDK installer hash")
}

msiexec /i OpenJDK17.msi ADDLOCAL=FeatureJavaHome /quiet
