#!/bin/sh

FILE=/root/grive.lock

if [ ! -f "$FILE" ]; then
   touch $FILE
   echo "Starting Sync"
   cd /drive
   grive $PARAMS
   rm $FILE
   echo "Finished Sync"
else
   echo "Lock-file present $FILE, try increasing time between runs, next schedule will be $CRON"
fi
if [ ! -z "${PERM}" ]; then
  chmod ${PERM} -R /drive
fi