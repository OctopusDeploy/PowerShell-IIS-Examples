### Creating application pools

You need to assign each application (website or application in a virtual directory) to an *application pool*. The application pool defines the executable process in which requests to the application are handled. 

IIS comes with a handful of application pools already defined for common options, but I always recommend creating your own application pool for each website or application that you deploy. This provides process-level isolation between applications and lets you set different permissions around what each application can do. The examples below show many of the common application pool settings. For the IIS Administration module, there are no built-in CmdLets to create application pools, so you have to do it with the `ServerManager` object directly.
