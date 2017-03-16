### Changing logging settings

HTTP request logging is provided by IIS and can be specified server-wide or on an individual site level. Applications and virtual directories can disable logging, but they can't do any logging of their own. The examples below show how to set logging at the site level. 

Logging settings are stored in `applicationHost.config` underneath the site:

```xml
<system.applicationHost>
    <!-- ... -->
    <sites>
        <site name="Default Web Site" id="1">
            <bindings>
                <binding protocol="http" bindingInformation="*:80:" />
            </bindings>
            <logFile logFormat="IIS" directory="%SystemDrive%\inetpub\logs\LogFiles1" period="Hourly" />
        </site>
        <siteDefaults>
            <logFile logFormat="W3C" directory="%SystemDrive%\inetpub\logs\LogFiles" />
            <traceFailedRequestsLogging directory="%SystemDrive%\inetpub\logs\FailedReqLogFiles" />
        </siteDefaults>
        <!-- ... -->
```