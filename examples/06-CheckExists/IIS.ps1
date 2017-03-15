# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue

$manager = Get-IISServerManager
$manager.ApplicationPools.Add("My Pool")
$manager.Sites.Add("Website1", "http", "*:8022:", "C:\Sites\Website1")
$manager.Sites["Website1"].Applications.Add("/MyApp", "C:\Sites\MyApp")
$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager

# The pattern here is to get the things you want, then check if they are null

if ($manager.ApplicationPools["My Pool"] -eq $null) {
    # Application pool does not exist, create it...
    # ...
}

if ($manager.Sites["Website1"] -eq $null) {
    # Site does not exist, create it...
    # ...
}

if ($manager.Sites["Website1"].Applications["/MyApp"] -eq $null) {
    # App/virtual directory does not exist, create it...
    # ...
}

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------
if ($manager.ApplicationPools["My Pool"] -eq $null -or $manager.ApplicationPools["sdij18uc"] -ne $null) { Write-Error "Our logic is wrong" }
if ($manager.Sites["Website1"] -eq $null -or $manager.Sites["isjdjdsoidj"] -ne $null) { Write-Error "Our logic is wrong" }
if ($manager.Sites["Website1"].Applications["/MyApp"] -eq $null -or $manager.Sites["Website1"].Applications["/sdidsuidshdsh"] -ne $null) { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false

$manager = Get-IISServerManager
$manager.ApplicationPools["My Pool"].Delete()
$manager.CommitChanges()
