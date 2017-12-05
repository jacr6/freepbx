#!/bin/bash

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


yum -y install lynx tftp-server unixODBC mysql-connector-odbc mariadb-server mariadb \
  httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel \
  audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie \
  cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls-devel python-devel texinfo \
  libuuid-devel
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y remove php*
yum -y install php56w php56w-pdo php56w-mysql php56w-mbstring php56w-pear php56w-process php56w-xml php56w-opcache php56w-ldap php56w-intl php56w-soap
wait ${!}


curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum -y  install -y nodejs
systemctl enable mariadb.service
systemctl start mariadb
wait ${!}

mysql_secure_installation
systemctl enable httpd.service
systemctl start httpd.service
wait ${!}

pear install Console_Getopt
wait ${!}


cd /usr/src
wget https://github.com/meduketto/iksemel/archive/master.zip -O iksemel-master.zip
unzip iksemel-master.zip
rm -f iksemel-master.zip
cd iksemel-master
./autogen.sh
./configure
wait ${!}


make
wait ${!}

make install
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


cd /usr/src
tar xvfz asterisk-14-current.tar.gz
rm -f asterisk-14-current.tar.gz
cd asterisk-*
contrib/scripts/install_prereq install
./configure --libdir=/usr/lib64 --with-pjproject-bundled
contrib/scripts/get_mp3_source.sh
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

cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-14.0-latest.tgz
tar xfz freepbx-14.0-latest.tgz
rm -f freepbx-14.0-latest.tgz
cd freepbx
./start_asterisk start
./install -n
wait ${!}


