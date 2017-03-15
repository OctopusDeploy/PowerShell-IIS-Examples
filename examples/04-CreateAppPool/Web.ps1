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

# What version of the .NET runtime to use. Valid options are "v2.0" and 
# "v4.0". IIS Manager often presents them as ".NET 4.5", but these still 
# use the .NET 4.0 runtime so should use "v4.0". For a "No Managed Code" 
# equivalent, pass an empty string.
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "managedRuntimeVersion" -value "v4.0"

# If your ASP.NET app must run as a 32-bit process even on 64-bit machines
# set this to $true. This is usually only important if your app depends 
# on some unmanaged (non-.NET) DLL's. 
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "enable32BitAppOnWin64" -value $false

# Starts the application pool automatically when a request is made. If you 
# set this to false, you have to manually start the application pool or 
# you will get 503 errors. 
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "autoStart" -value $true

# What account does the application pool run as? 
# "ApplicationPoolIdentity" = best
# "LocalSysten" = bad idea!
# "NetworkService" = not so bad
# "SpecificUser" = useful if the user needs special rights. See other examples
# below for how to do this.
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "processModel" -value @{identitytype="ApplicationPoolIdentity"}

# Older applications may require "Classic" mode, but most modern ASP.NET
# apps use the integrated pipeline. 
# 
# On newer versions of PowerShell, setting the managedPipelineMode is easy -
# just use a string:
# 
#   Set-ItemProperty -Path "IIS:\AppPools\My Pool 3" `
#      -name "managedPipelineMode" ` 
#      -value "Integrated"
# 
# However, the combination of PowerShell and the IIS module in Windows 
# Server 2008 and 2008 R2 requires you to specify the value as an integer.
#
#  0 = Integrated
#  1 = Classic
# 
# If you hate hard-coding magic numbers you can do this (or use the string
# if 2008 support isn't an issue for you):
#  
#   Add-Type -Path "${env:SystemRoot}\System32\inetsrv\Microsoft.Web.Administration.dll"
#   $pipelineMode = [Microsoft.Web.Administration.ManagedPipelineMode]::Integrated
#   Set-ItemProperty -Path "..." -name "managedPipelineMode" -value ([int]$pipelineMode)
# 
# If this DLL doesn't exist, you'll need to install the IIS Management 
# Console role service.
Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "managedPipelineMode" -value 0

# This setting was added in IIS 8. It's different to autoStart (which means 
# "start the app pool when a request is made") in that it lets you keep 
# an app pool running at all times even when there are no requests. 
# Since it was added in IIS 8 you may need to check the OS version before
# trying to set it. 
# 
# "AlwaysRunning" = application pool loads when Windows starts, stays running
# even when the application/site is idle. 
# "OnDemand" = IIS starts it when needed. If there are no requests, it may 
# never be started. 
if ([Environment]::OSVersion.Version -ge (new-object 'Version' 6,2)) {
    Set-ItemProperty -Path "IIS:\AppPools\My Pool" -name "startMode" -value "OnDemand"
}

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------

if ((Get-WebAppPoolState -Name "My Pool") -eq $null) { Write-Error "Website1 not found" }
if ((Get-ItemProperty -Path "IIS:\AppPools\My Pool" -name "managedPipelineMode") -ne "Integrated") { Write-Error "Wrong pipeline mode" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.Web.ps1

Remove-Item -Path "IIS:\AppPools\My Pool" -Recurse -Force
