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

$pool = Get-IISAppPool -Name "My Pool" -WarningAction SilentlyContinue
if ($pool -eq $null) {
    $manager = Get-IISServerManager
    $pool = $manager.ApplicationPools.Add("My Pool")

    # Older applications may require "Classic" mode, but most modern ASP.NET
    # apps use the integrated pipeline
    $pool.ManagedPipelineMode = "Integrated"

    # What version of the .NET runtime to use. Valid options are "v2.0" and 
    # "v4.0". IIS Manager often presents them as ".NET 4.5", but these still 
    # use the .NET 4.0 runtime so should use "v4.0". For a "No Managed Code" 
    # equivalent, pass an empty string.
    $pool.ManagedRuntimeVersion = "v4.0"

    # If your ASP.NET app must run as a 32-bit process even on 64-bit machines
    # set this to $true. This is usually only important if your app depends 
    # on some unmanaged (non-.NET) DLL's. 
    $pool.Enable32BitAppOnWin64 = $false

    # Starts the application pool automatically when a request is made. If you 
    # set this to false, you have to manually start the application pool or 
    # you will get 503 errors. 
    $pool.AutoStart = $true

    # "AlwaysRunning" = application pool loads when Windows starts, stays running
    # even when the application/site is idle. 
    # "OnDemand" = IIS starts it when needed. If there are no requests, it may 
    # never be started. 
    $pool.StartMode = "OnDemand"

    # What account does the application pool run as? 
    # "ApplicationPoolIdentity" = best
    # "LocalSysten" = bad idea!
    # "NetworkService" = not so bad
    # "SpecificUser" = useful if the user needs special rights
    $pool.ProcessModel.IdentityType = "ApplicationPoolIdentity"

    $manager.CommitChanges()
}

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