clear
Write-Host "Loading modules"

Import-Module IISAdministration -ErrorAction SilentlyContinue

# We use this folder for testing, often as the physical directory for sites
mkdir "C:\Sites" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MySite" -ErrorAction SilentlyContinue

# In case previous invocations left one open
Stop-IISCommitDelay -commit $false -WarningAction SilentlyContinue
Stop-IISCommitDelay -commit $false -WarningAction SilentlyContinue