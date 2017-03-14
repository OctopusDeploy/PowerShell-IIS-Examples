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

Start-IISCommitDelay

New-IISSite -Name "Website1" -BindingInformation "*:8022:" -PhysicalPath "C:\Sites\Website1"

$site = Get-IISSite -Name "Website1"
$site.Id = 4
$site.Bindings.Add("*:8023:", "http")
$site.Bindings.Add("*:8024:", "http")

Stop-IISCommitDelay -Commit $true

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-IISSite -Name "Website1") -eq $null) { Write-Error "Website1 not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false
