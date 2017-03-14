### Creating application pools

It's a good practice to create an application pool for each web site and application that you deploy. This provides process-level isolation between applications and lets you set different permissions around what each application can do. The examples below show many of the common application pool settings. For the IIS Administration module, there are no built-in CmdLets to create application pools, so you have to do it with the `ServerManager` object directly.
