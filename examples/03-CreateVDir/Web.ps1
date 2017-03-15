# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MyApp" -ErrorAction SilentlyContinue

New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

New-Item -Type Application -Path "IIS:\Sites\Website1\MyApp" -physicalPath "C:\Sites\MyApp"

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Test-Path IIS:\Sites\Website1\MyApp) -eq $false) { Write-Error "App not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
