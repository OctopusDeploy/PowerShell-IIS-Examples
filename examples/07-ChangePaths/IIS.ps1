# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Website1\1.0" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Website1\1.1" -ErrorAction SilentlyContinue

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

# Remember, in the IIS Administration view of the world, sites contain 
# applications, and applications contain virtual directories, and it is 
# virtual directories that point at a physical path on disk. 

# Change for a top-level website
$manager.Sites["Website1"].Applications["/"].VirtualDirectories["/"].PhysicalPath = "C:\Sites\Website1\1.1"

# Change for an app within a website
$manager.Sites["Website1"].Applications["/MyApp"].VirtualDirectories["/"].PhysicalPath = "C:\Sites\Website1\1.1"

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------
if ($manager.Sites["Website1"].Applications["/"].VirtualDirectories["/"].PhysicalPath -ne "C:\Sites\Website1\1.1") { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false

$manager = Get-IISServerManager
$manager.ApplicationPools["My Pool"].Delete()
$manager.CommitChanges()
