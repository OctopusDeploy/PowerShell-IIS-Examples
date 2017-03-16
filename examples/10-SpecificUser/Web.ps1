# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $here

. ..\_Setup.Web.ps1

Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force -ErrorAction SilentlyContinue

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------

Import-Module WebAdministration

New-Item -Path "IIS:\AppPools" -Name "My Pool" -Type AppPool

$identity = @{  `
    identitytype="SpecificUser"; `
    username="My Username"; `
    password="My Password" `
}
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "processModel" -value $identity

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-WebAppPoolState -Name "My Pool") -eq $null) { Write-Error "Pool not found" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force
