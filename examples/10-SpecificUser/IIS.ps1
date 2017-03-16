# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager
$pool = $manager.ApplicationPools.Add("My Pool")
$pool.ProcessModel.IdentityType = "SpecificUser"
$pool.ProcessModel.Username = "My User"
$pool.ProcessModel.Password = "Password"

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-IISAppPool -Name "My Pool") -eq $null) { Write-Error "My Pool not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

$manager = Get-IISServerManager
$manager.ApplicationPools["My Pool"].Delete()
$manager.CommitChanges()