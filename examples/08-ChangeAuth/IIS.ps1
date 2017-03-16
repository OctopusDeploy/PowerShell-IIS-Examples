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
$manager.Sites.Add("Website1", "http", "*:8022:", "C:\Sites\Website1")
$manager.Sites["Website1"].Applications.Add("/MyApp", "C:\Sites\MyApp")
$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Example
# -----------------------------------------------------------------------------
Import-Module IISAdministration

$manager = Get-IISServerManager

# ServerManager makes it easy to get the various config files that belong to 
# an app, or at the applicationHost level. Since this setting is locked
# to applicationHost, we need to get the applicationHost configuration. 
$config = $manager.GetApplicationHostConfiguration()

# Note that we have to specify the name of the site or application we are 
# editing, since we are working with individual <location> sections within
# the global applicationHost.config file.
$section = $config.GetSection(`
    "system.webServer/security/authentication/windowsAuthentication", `
    "Website1")
$section.Attributes["enabled"].Value = $true

# The section paths are:
# 
#  Anonymous: system.webServer/security/authentication/anonymousAuthentication
#  Basic:     system.webServer/security/authentication/basicAuthentication
#  Windows:   system.webServer/security/authentication/windowsAuthentication

# Changing options for an application in a virtual directory is similar, 
# just specify the site name and app name together:
$section = $config.GetSection(`
    "system.webServer/security/authentication/windowsAuthentication", `
    "Website1/MyApp")
$section.Attributes["enabled"].Value = $true

$manager.CommitChanges()

# -----------------------------------------------------------------------------
# Assert
# -----------------------------------------------------------------------------
if ($manager.Sites["Website1"].Applications["/MyApp"].GetWebConfiguration().GetSection("system.webServer/security/authentication/windowsAuthentication").Attributes["enabled"].Value -ne "true") { Write-Error "Our logic is wrong" }

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

. ..\_Teardown.IIS.ps1

Remove-IISSite -Name "Website1" -Confirm:$false
