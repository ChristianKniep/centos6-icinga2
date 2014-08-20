#!/bin/bash

MYSQLPW_ROOT=${MYSQLPW_ROOT-root}
MYSQLPW_ICINGA=${MYSQLPW_ICINGA-icinga}
MYSQLPW_ICINGAWEB=${MYSQLPW_ICINGAWEB-icingaweb}

if [ ! -f /var/run/icinga2web_init ];then
    cd /usr/local/icingaweb/config/
    sed -i -e 's/;type.* = db/type        = db/' config.ini
    sed -i -e 's/;resource.*= icingaweb-mysql/resource    = internal_db/' config.ini
    touch /var/run/icinga2web_init
fi
sleep 1

exit 0