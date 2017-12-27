#!/bin/bash
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

wait ${!}

yum -y update
yum -y groupinstall core base "Development Tools"
wait ${!}


firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
wait ${!}


yum -y install lynx tftp-server unixODBC mysql-connector-odbc mariadb-server mariadb 
yum -y install  httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel 
yum -y install  audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie 
yum -y install  cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls-devel python-devel texinfo 
yum -y install libuuid-devel
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y remove php*
wait ${!}


curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum -y  install -y nodejs
systemctl enable mariadb.service
systemctl start mariadb
wait ${!}

mysql_secure_installation

wait ${!}

pear install Console_Getopt
wait ${!}





cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-14-current.tar.gz
wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.10.tar.gz
wait ${!}



cd /usr/src
tar xvfz dahdi-linux-complete-current.tar.gz
tar xvfz libpri-current.tar.gz
rm -f dahdi-linux-complete-current.tar.gz libpri-current.tar.gz
cd dahdi-linux-complete-*
wait ${!}

make all
wait ${!}
make install
wait ${!}
make config
wait ${!}

cd /usr/src/libpri-*
wait ${!}
make
wait ${!}
make install
wait ${!}

cd /usr/src
tar vxfz jansson.tar.gz
rm -f jansson.tar.gz
wait ${!}


cd jansson-*
autoreconf -i
wait ${!}
./configure --libdir=/usr/lib64
wait ${!}
make
wait ${!}
make install
wait ${!}

adduser asterisk -M -c "Asterisk User"
mkhomedir_helper asterisk

cd /usr/src
rm -rf asterisk*
tar xvfz asterisk-14-current.tar.gz
rm -f asterisk-14-current.tar.gz
cd asterisk-*
contrib/scripts/install_prereq install
./configure --libdir=/usr/lib64 --with-pjproject-bundled
contrib/scripts/get_mp3_source.sh
make menuselect.makeopts
wait ${!}


make
wait ${!}
make install
wait ${!}
make config
wait ${!}
ldconfig
wait ${!}

chkconfig asterisk off
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /usr/lib64/asterisk
chown -R asterisk. /var/www/
sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
wait ${!}

systemctl restart httpd.service
wait ${!}


wget -P /etc/yum.repos.d/ -N http://yum.schmoozecom.net/schmooze-commercial/schmooze-commercial.repo
yum clean all
yum -y install sysadmin fail2ban incron ImageMagick

service httpd restart
wait ${!}

#Author add
mkdir /tftpboot
chown -R asterisk:asterisk /tftpboot
chown -R asterisk:asterisk /var/log/asterisk
chown -R asterisk:asterisk /var/run/asterisk
chown -R asterisk:asterisk /var/lib/asterisk
chown -R asterisk:asterisk /var/log/asterisk/*
chown -R asterisk:asterisk /var/run/asterisk/*
chown -R asterisk:asterisk /var/lib/asterisk/*

systemctl enable asterisk.service
systemctl start asterisk.service

sleep 10
reboott
