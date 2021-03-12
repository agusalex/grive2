
# grive2Docker

[![Docker Hub package][dockerhub-badge]][dockerhub-link]

[dockerhub-badge]: https://img.shields.io/badge/images%20on-Docker%20Hub-blue.svg
[dockerhub-link]: https://hub.docker.com/repository/docker/agusalex/grive2 "Docker Hub Image"

Docker Container for [grive2](https://github.com/vitalif/grive2) by **vitalif**

 - This will sync **all** Drive account's folders and files to a path
   specified 
  - It can be configured to sync **some folders** only using
   grives parameters
 -  **It runs on schedule given by the crontab** you can configure that in the CRON parameter.
- This container's snapshot tag will be built automatically on docker hub every 1st of the month based on the master branch of grive2. 
# Environmental Variables
| Variable |Description  |
|--|--|
|**PARAMS**  | Passes the parameters to **grive2**. see **Grive Settings** bellow |
|**ID**  | Your Google Client ID |
|**SECRET**  | Your Google Secret |
|**CODE**  | Your Google Code |
|**CRON**  | [Cron Schedule](https://crontab.guru/) |
|**PERM**  |  [Unix Permissions](https://chmod-calculator.com/) to set on all files in folder   |

# Google Drive Setup
- Go to https://console.developers.google.com/apis/library. 
- Login with your Google account and create a new project on Google Cloud Platform. You can also use an existing one.
- Search for Google Drive API and enable it.
- Go to API Credentials page (https://console.developers.google.com/apis/credentials)
- Create a new OAuth Client credential. Select TV as device type. You will be provided with a id and a secret. 
- Save both **ID** and **SECRET** because you're going to need it for grive2.

# Running
- Run this container  with these **ENV** options : 
```docker run -it -e ID=CLIENT_ID -e SECRET=SECRET  -v /your/host/folder:/drive agusalex/grive2 ```
- Go to the provided URL -> Grant Access then copy and paste the **CODE** when prompted in the terminal
- It will start sync
- Enjoy Grive2!! 

Now you can run it without the environmental variables as these get saved into the folder, just run it like this so that it stays like a background process:
```
docker run -v /your/host/folder:/drive agusalex/grive2 
```


## Optional
If you already have your response code you can use this (warning this will expose your credentials to anyone with access to the computer)
```
docker run -it -e ID=CLIENT_ID -e SECRET=SECRET -e CODE=CODE -v /your/host/folder:/drive agusalex/grive2 
```


You can always grab your response code by appending your **ID** to this URL:

https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id= **FILL_HERE_YOUR_CLIENT_ID**


# Grive Settings

For setting your own Grive configs for example syncing only one folder with **-s** you may use the PARAMS environmental variable as so:
```
docker run -it -v /your/host/folder:/drive -e PARAMS="-s folder_name" agusalex/grive2 
```

| Parameter| Description |
|--|--|
|**-s** your_folder|Single subdirectory to sync (remembered for next runs)  |
|**--ignore** regex |Perl RegExp to ignore files (matched against relative paths, remembered for next runs).  |
|**--new-rev**|  Create new revisions in server for updated files.  |
|**--force** |Force grive to always download a file from Google Drive instead of uploading it.  |
|**--dry-run** |Only detect which files need to be uploaded/downloaded, without actually performing them.  |

For more info on Grive2, all docs can be found here https://yourcmc.ru/wiki/Grive2
