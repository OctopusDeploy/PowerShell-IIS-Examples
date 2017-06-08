#Script to edit the feature permissions for individual Site Handler Mappings in IIS

Import-Module WebAdministration

#Set location of your sites. 
$site = "IIS:\Sites"

#enter the setting for the "Edit Feature Permissions" Read, Script, Execute    -   Execute require script.
$setpolicy = "Read, Script"

#Sets the Handler Mapping feature delegation to Read/Write
Set-WebConfiguration //System.webServer/handlers -metadata overrideMode -value Allow -PSPath IIS:/ -verbose

#Sets the AccessPolicy for @site to $setpolicy value.
Set-WebConfiguration -filter "/system.webServer/handlers/@AccessPolicy" -PSPath $site -value $setpolicy -verbose

#Sets the Handler Mapping feature delegation to Read Only. (Left commented out by default)
#Set-WebConfiguration //System.webServer/handlers -metadata overrideMode -value Deny -PSPath IIS:/ -verbos
