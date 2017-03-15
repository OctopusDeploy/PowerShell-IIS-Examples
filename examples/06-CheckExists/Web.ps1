# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MyApp" -ErrorAction SilentlyContinue

New-Item -Path "IIS:\AppPools" -Name "My Pool" -Type AppPool
New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"
New-Item -Type Application -Path "IIS:\Sites\Website1\MyApp" -physicalPath "C:\Sites\MyApp"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

# The pattern here is to use Test-Path with the IIS:\ drive provider

if ((Test-Path "IIS:\AppPools\My Pool") -eq $False) {
    # Application pool does not exist, create it...
    # ...
}

if ((Test-Path "IIS:\Sites\Website1") -eq $False) {
    # Site does not exist, create it...
    # ...
}

if ((Test-Path "IIS:\Sites\Website1\MyApp") -eq $False) {
    # App/virtual directory does not exist, create it...
    # ...
}

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Test-Path "IIS:\AppPools\My Pool") -eq $false -or (Test-Path "IIS:\AppPools\sijsijd") -ne $false) { Write-Error "Our logic is wrong" }
if ((Test-Path "IIS:\Sites\Website1") -eq $false -or (Test-Path "IIS:\Sites\sdijdsijdd") -ne $false) { Write-Error "Our logic is wrong" }
if ((Test-Path "IIS:\Sites\Website1\MyApp") -eq $false -or (Test-Path "IIS:\Sites\Website1\sdddsds") -ne $false) { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force
