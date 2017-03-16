### Changing authentication methods

IIS supports a number of authentication methods. As described above, these are "locked" to `applicationHost.config` by default - so if you want to automatically enable them. The examples below show how to enable/disable: 

 - Anonymous authentication
 - Basic authentication
 - Digest authentication
 - Windows authentication

IIS Manager also shows "ASP.NET impersonation" and "Forms authentication" as settings at the same level, but these are actually set in your app's `web.config` file so I've left them out of here. 