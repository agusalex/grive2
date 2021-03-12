#!/bin/sh

runGrive(){
  if [ -z "$CRON" ]; then
    echo "Crontab Not Present running one time now"
    grive $PARAMS
  else
    echo "$CRON /root/run.sh" > /etc/crontabs/root;
    echo "Next run will be scheduled by the following cron $CRON"
    crond -f -d 8;
  fi
}

rm -f /root/grive.lock
echo "Starting Grive2 Docker..."
if [ -f /drive/.grive ]; then
    echo "Configuration Exists!"
    runGrive
else
    if [ -z "$ID" ]; then
        echo "
                Configuration is missing...
                First Time Setup (Action Required):	
                - Go to https://github.com/agusalex/grive2Docker/wiki/Setup and follow the guide!
                
                "
    else

        if [ -z "$CODE" ]; then
            echo "Configuration is missing...
                      Starting setup... "
            grive $PARAMS -a --id $ID --secret $SECRET #First run is with params
            runGrive

        else
            echo "Auto-Configuring with provided authCode..."
            echo -ne "$CODE\n" | grive $PARAMS -a --id $ID --secret $SECRET #First run is with params
            runGrive
        fi
    fi
fi
if [ ! -z "${PERM}" ]; then
  chmod ${PERM} -R /drive
fi