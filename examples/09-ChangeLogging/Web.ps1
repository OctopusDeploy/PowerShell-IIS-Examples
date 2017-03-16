# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Logs" -ErrorAction SilentlyContinue

New-Website -Name "Website1" -Port 80 -IPAddress "*" -HostHeader "" -PhysicalPath "C:\Sites\Website1"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

$settings = @{ `
    logFormat="W3c";                `   # Formats:   W3c, Iis, Ncsa, Custom
    enabled=$true;                  `
    directory="C:\Sites\Logs";      `
    period="Daily";                 `
}

Set-ItemProperty "IIS:\Sites\Website1" -name "logFile" -value $settings

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-ItemProperty "IIS:\Sites\Website1" -name "logFile.directory") -ne "C:\Sites\Logs") { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\Sites\Website1" -Recurse -Force
