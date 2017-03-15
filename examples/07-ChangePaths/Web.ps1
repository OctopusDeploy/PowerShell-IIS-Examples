# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Website1\1.0" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Website1\1.1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MyApp" -ErrorAction SilentlyContinue

New-Item -Path "IIS:\AppPools" -Name "My Pool" -Type AppPool
New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"
New-Item -Type Application -Path "IIS:\Sites\Website1\MyApp" -physicalPath "C:\Sites\MyApp"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

# The pattern here is to use Test-Path with the IIS:\ drive provider

Set-ItemProperty -Path "IIS:\Sites\Website1" -name "physicalPath" -value "C:\Sites\Website1\1.1"
Set-ItemProperty -Path "IIS:\Sites\Website1\MyApp" -name "physicalPath" -value "C:\Sites\Website1\1.1"

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-ItemProperty -Path "IIS:\Sites\Website1" -name "physicalPath") -ne "C:\Sites\Website1\1.1") { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force
