# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module IISAdministration

New-IISSite -Name "Website1" -BindingInformation "*:80:" -PhysicalPath "C:\Sites\Website1"

# Examples of -BindingInformation: 
#    "*:80:"                - Listens on port 80, any IP address, any hostname
#    "10.0.0.1:80:"         - Listens on port 80, specific IP address, any host
#    "*:80:myhost.com"      - Listens on port 80, specific hostname

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-IISSite -Name "Website1") -eq $null) { Write-Error "Website1 not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false
