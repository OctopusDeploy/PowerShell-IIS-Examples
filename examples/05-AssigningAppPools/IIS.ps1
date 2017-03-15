# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue

New-IISSite -Name "Website1" -BindingInformation "*:8022:" -PhysicalPath "C:\Sites\Website1"

$manager = Get-IISServerManager
$pool = $manager.ApplicationPools.Add("My Pool")
$app = $manager.Sites["Website1"].Applications.Add("/MyApp", "C:\Sites\MyApp")
$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager

# Assign to a website
$website = $manager.Sites["Website1"]
$website.Applications["/"].ApplicationPoolName = "My Pool"

# Assign to an application in a virtual directory
$website = $manager.Sites["Website1"]
$website.Applications["/MyApp"].ApplicationPoolName = "My Pool"

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-IISAppPool -Name "My Pool") -eq $null) { Write-Error "My Pool not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false

$manager = Get-IISServerManager
$manager.ApplicationPools["My Pool 3"].Delete()
$manager.CommitChanges()
