#!/bin/bash

function watch_pid {
    if [ -f $1 ];then
        sleep 5
        watch_pid $1
    else
        exit 1
    fi
}

if [ ! -f /var/run/icinga2_mysql_init ];then
    mysql_install_db >/dev/null
    sleep 2
fi

/usr/bin/mysqld_safe &
sleep 5

MYSQLPW_ROOT=${MYSQLPW_ROOT-root}
MYSQLPW_ICINGA=${MYSQLPW_ICINGA-icinga}
MYSQLPW_ICINGAWEB=${MYSQLPW_ICINGAWEB-icingaweb}

if [ ! -f /var/icinga2_mysql_init ];then
    mysqladmin -u root password ${MYSQLPW_ROOT}
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE USER icinga@localhost IDENTIFIED BY '${MYSQLPW_ICINGA}';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE USER icingaweb@localhost IDENTIFIED BY '${MYSQLPW_ICINGAWEB}';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE DATABASE icinga;"
    mysql -uroot -p${MYSQLPW_ROOT} -e "GRANT ALL PRIVILEGES ON icinga.* TO 'icinga'@'localhost';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE DATABASE icingaweb;"
    mysql -uroot -p${MYSQLPW_ROOT} -e "GRANT ALL PRIVILEGES ON icingaweb.* TO 'icingaweb'@'localhost';"
    mysql -uroot -p${MYSQLPW_ROOT} -e "FLUSH PRIVILEGES;"
    # icinga2
    mysql -uicinga -p${MYSQLPW_ICINGA} icinga < /usr/share/doc/icinga2-ido-mysql-2.0.2/schema/mysql.sql
    sleep 1
    icinga2-enable-feature ido-mysql
    sleep 1
    # icinga2web
    mysql -uicingaweb -p${MYSQLPW_ICINGAWEB} icingaweb < /etc/icinga2web_schema/accounts.mysql.sql
    mysql -uicingaweb -p${MYSQLPW_ICINGAWEB} icingaweb < /etc/icinga2web_schema/preferences.mysql.sql
    touch /var/run/icinga2_mysql_init
fi

watch_pid /var/run/mysqld/mysqld.pid
