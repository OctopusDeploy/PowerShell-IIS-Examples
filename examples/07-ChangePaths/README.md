### Change physical path of a site or application

When deploying a new version of an application, my preference (and the way Octopus Deploy works) is to deploy to a fresh, new folder on disk, then update IIS to point to it. So you begin with:

    C:\Sites\Website1\1.0   <--- IIS points here

You deploy the new version:

    C:\Sites\Website1\1.0   <--- IIS points here
    C:\Sites\Website1\1.1

You can then make any necessary changes to configuration files, etc. and then update IIS to point to it:

    C:\Sites\Website1\1.0
    C:\Sites\Website1\1.1   <--- Now IIS points here

Should you ever need to roll back in a hurry, you can leave the old folder on disk and point back to it:

    C:\Sites\Website1\1.0   <--- IIS points here (we rolled back manually)
    C:\Sites\Website1\1.1   
