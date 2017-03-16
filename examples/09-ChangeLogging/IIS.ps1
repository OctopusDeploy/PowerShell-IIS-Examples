# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.IIS.ps1

mkdir "C:\Sites\Website1" -ErrorAction SilentlyContinue
mkdir "C:\Sites\Logs" -ErrorAction SilentlyContinue

$manager = Get-IISServerManager
$manager.Sites.Add("Website1", "http", "*:8022:", "C:\Sites\Website1")
$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager

$site = $manager.Sites["Website1"]
$logFile = $site.LogFile
$logFile.LogFormat = "W3c"               # Formats:   W3c, Iis, Ncsa, Custom
$logFile.Directory = "C:\Sites\Logs"     
$logFile.Enabled = $true
$logFile.Period = "Daily"

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------
if ($manager.Sites["Website1"].LogFile.Directory -ne "C:\Sites\Logs") { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false
