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

New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"
New-Item -Type Application -Path "IIS:\Sites\Website1\MyApp" -physicalPath "C:\Sites\MyApp"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

# The pattern here is to use Test-Path with the IIS:\ drive provider. 

Set-WebConfigurationProperty `
    -Filter "/system.webServer/security/authentication/windowsAuthentication" `
    -Name "enabled" `
    -Value $true `
    -Location "Website1/MyApp" `
    -PSPath IIS:\    # We are using the root (applicationHost.config) file

# The section paths are:
# 
#  Anonymous: system.webServer/security/authentication/anonymousAuthentication
#  Basic:     system.webServer/security/authentication/basicAuthentication
#  Windows:   system.webServer/security/authentication/windowsAuthentication

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-WebConfigurationProperty -PSPath "IIS:\Sites\Website1\MyApp" -Filter "/system.webServer/security/authentication/windowsAuthentication" -Name "enabled") -ne $true) { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
