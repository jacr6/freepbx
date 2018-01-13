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


yum -y install  audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie 
yum -y install  cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls-devel python-devel texinfo 
yum -y install libuuid-devel
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y remove php*
yum -y install php56w php56w-pdo php56w-mysql php56w-mbstring php56w-pear php56w-process php56w-xml php56w-opcache php56w-ldap php56w-intl php56w-soap
wait ${!}




cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-1.8.30.0.tar.gz

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



adduser asterisk -M -c "Asterisk User"
mkhomedir_helper asterisk

cd /usr/src

tar xvfz asterisk-14-current.tar.gz
rm -f asterisk-14-current.tar.gz
cd asterisk-*
contrib/scripts/install_prereq install
./configure 
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
wait ${!}


mkdir /tftpboot
chown -R asterisk:asterisk /tftpboot
chown -R asterisk:asterisk /var/log/asterisk
chown -R asterisk:asterisk /var/run/asterisk
chown -R asterisk:asterisk /var/lib/asterisk
chown -R asterisk:asterisk /var/log/asterisk/*
chown -R asterisk:asterisk /var/run/asterisk/*
chown -R asterisk:asterisk /var/lib/asterisk/*
