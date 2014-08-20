###### Icinga Image
FROM qnib/centos6_supervisor
MAINTAINER "Christian Kniep <christian@qnib.org>"


# install icinga
ADD etc/yum.repos.d/ICINGA-release.repo /etc/yum.repos.d/ICINGA-release.repo
RUN yum install -y icinga2 icinga2-ido-mysql icinga2-doc
### WORKAROUND
# Since CentOS somehow prevents files from beeing installed
# underneath /usr/share/doc
ADD usr/ /usr/
RUN mkdir -p /var/run/icinga2
ADD etc/supervisord.d/icinga2.ini /etc/supervisord.d/icinga2.ini

# nagios-plugins
ADD etc/yum.repos.d/qnib.repo /etc/yum.repos.d/qnib.repo
RUN yum install -y qnib-nagios-plugins

# icinga2-web
RUN yum install -y http://epel.mirrors.ovh.net/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y php php-ZendFramework php-pgsql php-ZendFramework-Db-Adapter-Pdo-Mysql php-ZendFramework-Db-Adapter-Pdo-Pgsql php-ldap
RUN echo "2014-08-20";yum clean all;yum install -y qnib-icinga2web
ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini
ADD root/bin/setup_icinga2web.sh /root/bin/
ADD etc/supervisord.d/setup_icinga2web.ini /etc/supervisord.d/
RUN chown apache: -R /usr/local/icingaweb/*

# mysql
RUN yum install -y mysql-server
ADD etc/supervisord.d/mysqld.ini /etc/supervisord.d/
ADD etc/icinga2web_schema/ /etc/icinga2web_schema/
ADD root/bin/start_mysqld.sh /root/bin/start_mysqld.sh
#RUN useradd mysql -s /sbin/nologin
RUN chown mysql: -R /var/lib/mysql /var/run/mysqld

EXPOSE 80

