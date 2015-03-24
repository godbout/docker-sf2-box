#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_users.sh
else
    echo "=> Using an existing volume of MySQL"
fi

# Giving same UID that laptop user so that www-data can write 
usermod -u 1000 www-data

exec supervisord -n