clear
Write-Host "Loading modules"

# Easiest way to load the module on 2008 (which used a SnapIn) and above (modules)
Add-PSSnapin WebAdministration -ErrorAction SilentlyContinue
Import-Module WebAdministration -ErrorAction SilentlyContinue

# We use this folder for testing, often as the physical directory for sites
mkdir "C:\Sites" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MySite" -ErrorAction SilentlyContinue
