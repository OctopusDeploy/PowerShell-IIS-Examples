# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\MyApp" -ErrorAction SilentlyContinue

New-IISSite -Name "Website1" -BindingInformation "*:8022:" -PhysicalPath "C:\Sites\Website1"

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager
$app = $manager.Sites["Website1"].Applications.Add("/MyApp", "C:\Sites\MyApp")
$app.ApplicationPoolName = ".NET v2.0"
$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false
