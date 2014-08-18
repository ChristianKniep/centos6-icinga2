#!/bin/bash

if [ -d /etc/icinga2web_schema/ ];then
    mysql_install_db
    sleep 2
fi
/usr/bin/mysqld_safe & 
sleep 5

MYSQLPW_ROOT=${MYSQLPW_ROOT-root}
MYSQLPW_ICINGA=${MYSQLPW_ICINGA-icinga}

if [ -d /etc/icinga2web_schema/ ];then
    mysqladmin -u root password ${MYSQLPW_ROOT}
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE USER icingaweb@localhost IDENTIFIED BY '${MYSQLPW_ICINGA}';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE DATABASE icingaweb;"
    mysql -uroot -p${MYSQLPW_ROOT} -e "GRANT ALL PRIVILEGES ON icingaweb.* TO 'icingaweb'@'localhost';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "FLUSH PRIVILEGES;"
    mysql -uicingaweb -p${MYSQLPW_ICINGA} icingaweb < /etc/icinga2web_schema/accounts.mysql.sql
    mysql -uicingaweb -p${MYSQLPW_ICINGA} icingaweb < /etc/icinga2web_schema/preferences.mysql.sql
    rm -rf /etc/icinga2web_schema/
fi
