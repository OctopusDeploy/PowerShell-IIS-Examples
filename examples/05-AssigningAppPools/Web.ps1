# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MyApp" -ErrorAction SilentlyContinue

New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"
New-Item -Type Application -Path "IIS:\Sites\Website1\MyApp" -physicalPath "C:\Sites\MyApp"
New-Item -Path "IIS:\AppPools" -Name "My Pool" -Type AppPool

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

# Assign the application pool to a website
Set-ItemProperty -Path "IIS:\Sites\Website1" -name "applicationPool" -value "My Pool"

# Assign the application pool to an application in a virtual directory
Set-ItemProperty -Path "IIS:\Sites\Website1\MyApp" -name "applicationPool" -value "My Pool"

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Test-Path IIS:\Sites\Website1\MyApp) -eq $false) { Write-Error "App not found" }
if ((Get-ItemProperty -Path "IIS:\Sites\Website1\MyApp" -name "applicationPool") -ne "My Pool") { Write-Error "Wrong app pool" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force
