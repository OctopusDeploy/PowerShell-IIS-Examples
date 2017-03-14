# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here
clear

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue

get-website

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Test-Path -Path "IIS:\Sites\Website1") -eq $false) { Write-Error "Couldn't find Website1" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
