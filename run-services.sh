#!/bin/bash

rccheck() {
   if [[ $? != 0 ]]; then
      echo "Error! Stopping the script."
      exit 1
   fi
}

if [ -f /root/logFacesServer/conf/initial-conf/lfs.xml ];
then
if [ ! -f /root/logFacesServer/conf/lfs.xml ];
then
   echo "Looks like it is the first run of lfs service"
   echo -n "Generating configs... " ; /etc/init.d/lfs start > /dev/null 2>&1 ; rccheck
   while [ ! -f /root/logFacesServer/conf/lfs.xml ];
   do
      sleep 2
   done
   /sbin/service lfs stop > /dev/null 2>&1 ; rccheck ; echo "done!"

   echo -n "Setting our configs instead of typical... "
   
   rm -rf /root/logFacesServer/db/ ; rccheck
   cp -fp /root/logFacesServer/conf/initial-conf/lfs.xml /root/logFacesServer/conf/lfs.xml ; rccheck 

   cp -fp /root/logFacesServer/conf/initial-conf/realm.properties /root/logFacesServer/conf/realm.properties ; rccheck

   if [ ! -f /root/logFacesServer/conf/hosts.properties ]; then
      touch /root/logFacesServer/conf/hosts.properties ; rccheck
   fi

   cp -fp /root/logFacesServer/conf/initial-conf/lfs.lic /root/logFacesServer/conf/lfs.lic ; rccheck

   echo "done!"

   touch /root/lfs-initiated
fi
fi

if [ ${MONGO_URL} ]; 
then
   sed -i 's/com.moonlit.logfaces.config.mongodb=.*/com.moonlit.logfaces.config.mongodb=true/' /root/logFacesServer/conf/environment.properties
   sed -i "s/com.moonlit.logfaces.config.mongodb.connection =.*/com.moonlit.logfaces.config.mongodb.connection=${MONGO_URL}/" /root/logFacesServer/conf/mongodb.properties

   sed -i 's/^com.moonlit.logfaces.config.mongodb.dbname  =.*/com.moonlit.logfaces.config.mongodb.dbname  = lfsp/' /root/logFacesServer/conf/mongodb.properties
   sed -i 's/^com.moonlit.logfaces.config.mongodb.ttlDays =.*/com.moonlit.logfaces.config.mongodb.ttlDays = 0/' /root/logFacesServer/conf/mongodb.properties
   sed -i 's/^com.moonlit.logfaces.config.mongodb.partitioned =.*/com.moonlit.logfaces.config.mongodb.partitioned = true/' /root/logFacesServer/conf/mongodb.properties
   sed -i 's/^com.moonlit.logfaces.config.mongodb.pdays =.*/com.moonlit.logfaces.config.mongodb.pdays = 1/' /root/logFacesServer/conf/mongodb.properties

fi


trap "/etc/init.d/lfs stop" SIGINT SIGTERM SIGHUP
/etc/init.d/lfs console &
wait
