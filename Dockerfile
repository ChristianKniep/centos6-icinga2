###### Icinga Image
FROM centos6/supervisor
MAINTAINER "Christian Kniep <christian@qnib.org>"


# install icinga
ADD etc/yum.repos.d/ICINGA-release.repo /etc/yum.repos.d/ICINGA-release.repo
RUN yum install -y icinga2
RUN mkdir -p /var/run/icinga2
# nagios-plugins
ADD etc/yum.repos.d/qnib.repo /etc/yum.repos.d/qnib.repo
RUN yum install -y qnib-nagios-plugins

EXPOSE 80

#####################
##### LEGACY!
#####################
# Install dependencies
#RUN yum install -y gcc glibc glibc-common gd gd-devel libjpeg libjpeg-devel libpng libpng-devel net-snmp net-snmp-devel net-snmp-utils

#RUN /usr/sbin/useradd -m icinga 
#RUN echo "icinga:icinga" |chpasswd
##RUN /usr/sbin/groupadd icinga
#RUN /usr/sbin/groupadd icinga-cmd
#RUN /usr/sbin/usermod -a -G icinga-cmd icinga

# Install httpd
#RUN yum install -y httpd
#RUN useradd apache
#RUN /usr/sbin/usermod -a -G icinga-cmd apache

# apache2
#RUN make install-webconf
#RUN htpasswd -b -c /usr/local/icinga/etc/htpasswd.users icingaadmin icinga

# Set (very simple) password for root
#RUN echo "root:root"|chpasswd
