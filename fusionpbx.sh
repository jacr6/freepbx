#!/bin/bash
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

wait ${!}




yum install epel-release
yum update

yum install git nano httpd mariadb-server php php-common php-pdo php-soap php-xml php-xmlrpc php-mysql php-cli php-imap php-mcrypt mysql-connector-odbc memcached ghostscript libtiff-devel libtiff-tools at



wait ${!}




## FIND YOUR TIMEZONE
tzselect

## SET TIMEZONE EXAMPLE
timedatectl set-timezone America/Puerto_Rico

## CHECK TIMEZONE
​timedatectl status

wait ${!}



rpm -Uvh http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm
yum install freeswitch-config-vanilla freeswitch-sounds* freeswitch-lang* freeswitch-lua freeswitch-xml-cdr

wait ${!}


systemctl start mariadb
wait ${!}

mysql -e "CREATE DATABASE freeswitch"
mysql -e "GRANT ALL PRIVILEGES ON freeswitch.* TO fusionpbx@localhost IDENTIFIED BY 'admin'" 
mysql -e "flush privileges"







cd /var/www/html
git clone -b 4.2 https://github.com/powerpbx/fusionpbx.git .


wait ${!}

mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R /var/www/html/resources/templates/conf/* /etc/freeswitch


wait ${!}





# Add user freeswitch to group apache to avoid problems with /var/lib/php/sessions directory 
usermod -a -G apache freeswitch

# Set http server to run as same user/group as Freeswitch
sed -i "s/User apache/User freeswitch/" /etc/httpd/conf/httpd.conf
sed -i "s/Group apache/Group daemon/" /etc/httpd/conf/httpd.conf

# Set webserver to obey any .htaccess files in /var/www/html and subdirs 
sed -i ':a;N;$!ba;s/AllowOverride None/AllowOverride All/2' /etc/httpd/conf/httpd.conf


wait ${!}


systemctl daemon-reload
systemctl enable mariadb
systemctl enable httpd
systemctl enable freeswitch
systemctl enable memcached
systemctl restart freeswitch

wait ${!}




> /etc/odbc.ini
cat <<EOT >> /etc/odbc.ini
[freeswitch]
Driver   = MySQL
SERVER   = 127.0.0.1
PORT     = 3306
DATABASE = freeswitch
OPTION  = 67108864
Socket   = /var/lib/mysql/mysql.sock
threading=0
MaxLongVarcharSize=65536

[fusionpbx]
Driver   = MySQL
SERVER   = 127.0.0.1
PORT     = 3306
DATABASE = fusionpbx
OPTION  = 67108864
Socket   = /var/lib/mysql/mysql.sock
threading=0
EOT


wait ${!}


odbcinst -s -q

isql -v freeswitch fusionpbx admin 

quit



wait ${!}



systemctl restart freeswitch

wait ${!}


mysql_secure_installation
systemctl restart mariadb
wait ${!}

echo 'CAMBIE EN /etc/freeswitch/autoload_configs/event_socket.conf.xml"'
echo '<param name="listen-ip" value="127.0.0.1"/>'


read -t 120 -p "Hit ENTER to continue" 


wait ${!}


echo " CAMBIE EN  /etc/freeswitch/autoload_configs/switch.conf.xml "
echo '<param name="core-db-dsn" value="freeswitch:fusionpbx:admin" /> '

read -t 120 -p "Hit ENTER to continue" 


sleep 120

# Ownership
chown -R freeswitch.daemon /etc/freeswitch /var/lib/freeswitch \
/var/log/freeswitch /usr/share/freeswitch /var/www/html



wait ${!}


# Directory permissions to 770 (u=rwx,g=rwx,o='')
find /etc/freeswitch -type d -exec chmod 770 {} \;
find /var/lib/freeswitch -type d -exec chmod 770 {} \;
find /var/log/freeswitch -type #!/bin/bash
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0

wait ${!}




yum install epel-release
yum update

yum install git nano httpd mariadb-server php php-common php-pdo php-soap php-xml php-xmlrpc php-mysql php-cli php-imap php-mcrypt mysql-connector-odbc memcached ghostscript libtiff-devel libtiff-tools at



wait ${!}




## FIND YOUR TIMEZONE
tzselect

## SET TIMEZONE EXAMPLE
timedatectl set-timezone America/Puerto_Rico

## CHECK TIMEZONE
​timedatectl status

wait ${!}



rpm -Uvh http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm
yum install freeswitch-config-vanilla freeswitch-sounds* freeswitch-lang* freeswitch-lua freeswitch-xml-cdr

wait ${!}


systemctl start mariadb
wait ${!}

mysql -e "CREATE DATABASE freeswitch"
mysql -e "GRANT ALL PRIVILEGES ON freeswitch.* TO fusionpbx@localhost IDENTIFIED BY 'admin'" 
mysql -e "flush privileges"







cd /var/www/html
git clone -b 4.2 https://github.com/powerpbx/fusionpbx.git .


wait ${!}

mv /etc/freeswitch /etc/freeswitch.orig
mkdir /etc/freeswitch
cp -R /var/www/html/resources/templates/conf/* /etc/freeswitch


wait ${!}





# Add user freeswitch to group apache to avoid problems with /var/lib/php/sessions directory 
usermod -a -G apache freeswitch

# Set http server to run as same user/group as Freeswitch
sed -i "s/User apache/User freeswitch/" /etc/httpd/conf/httpd.conf
sed -i "s/Group apache/Group daemon/" /etc/httpd/conf/httpd.conf

# Set webserver to obey any .htaccess files in /var/www/html and subdirs 
sed -i ':a;N;$!ba;s/AllowOverride None/AllowOverride All/2' /etc/httpd/conf/httpd.conf


wait ${!}


systemctl daemon-reload
systemctl enable mariadb
systemctl enable httpd
systemctl enable freeswitch
systemctl enable memcached
systemctl restart freeswitch

wait ${!}




> /etc/odbc.ini
cat <<EOT >> /etc/odbc.ini
[freeswitch]
Driver   = MySQL
SERVER   = 127.0.0.1
PORT     = 3306
DATABASE = freeswitch
OPTION  = 67108864
Socket   = /var/lib/mysql/mysql.sock
threading=0
MaxLongVarcharSize=65536

[fusionpbx]
Driver   = MySQL
SERVER   = 127.0.0.1
PORT     = 3306
DATABASE = fusionpbx
OPTION  = 67108864
Socket   = /var/lib/mysql/mysql.sock
threading=0
EOT


wait ${!}


odbcinst -s -q

isql -v freeswitch fusionpbx admin 

quit



wait ${!}



systemctl restart freeswitch

wait ${!}


mysql_secure_installation
systemctl restart mariadb
wait ${!}

echo 'CAMBIE EN /etc/freeswitch/autoload_configs/event_socket.conf.xml"'
echo '<param name="listen-ip" value="127.0.0.1"/>'


read -t 120 -p "Hit ENTER to continue" 


wait ${!}


echo " CAMBIE EN  /etc/freeswitch/autoload_configs/switch.conf.xml "
echo '<param name="core-db-dsn" value="freeswitch:fusionpbx:admin" /> '

read -t 120 -p "Hit ENTER to continue" 


sleep 120

# Ownership
chown -R freeswitch.daemon /etc/freeswitch /var/lib/freeswitch \
/var/log/freeswitch /usr/share/freeswitch /var/www/html



wait ${!}


# Directory permissions to 770 (u=rwx,g=rwx,o='')
find /etc/freeswitch -type d -exec chmod 770 {} \;
find /var/lib/freeswitch -type d -exec chmod 770 {} \;
find /var/log/freeswitch -type d -exec chmod 770 {} \;
find /usr/share/freeswitch -type d -exec chmod 770 {} \;
find /var/www/html -type d -exec chmod 770 {} \;



wait ${!}

# File permissions to 664 (u=rw,g=rw,o=r)
find /etc/freeswitch -type f -exec chmod 664 {} \;
find /var/lib/freeswitch -type f -exec chmod 664 {} \;
find /var/log/freeswitch -type f -exec chmod 664 {} \;
find /usr/share/freeswitch -type f -exec chmod 664 {} \;
find /var/www/html -type f -exec chmod 664 {} \;


wait ${!}

cat <<EOT >> /etc/systemd/system/freeswitch.service

[Unit]
Description=FreeSWITCH
Wants=network-online.target
After=syslog.target network-online.target
After=mariadb.service httpd.service

[Service]
Type=forking
User=freeswitch
ExecStartPre=/usr/bin/mkdir -m 0750 -p /run/freeswitch
ExecStartPre=/usr/bin/chown freeswitch:daemon /run/freeswitch
WorkingDirectory=/run/freeswitch
PIDFile=/run/freeswitch/freeswitch.pid
EnvironmentFile=-/etc/sysconfig/freeswitch
ExecStart=/usr/bin/freeswitch -ncwait -nonat $FREESWITCH_PARAMS
ExecReload=/usr/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

EOT


wait ${!}

cat <<EOT >> /etc/sysconfig/freeswitch


FREESWITCH_PARAMS=""


EOT


wait ${!}


systemctl restart freeswitch
wait ${!}


d -exec chmod 770 {} \;
find /usr/share/freeswitch -type d -exec chmod 770 {} \;
find /var/www/html -type d -exec chmod 770 {} \;



wait ${!}

# File permissions to 664 (u=rw,g=rw,o=r)
find /etc/freeswitch -type f -exec chmod 664 {} \;
find /var/lib/freeswitch -type f -exec chmod 664 {} \;
find /var/log/freeswitch -type f -exec chmod 664 {} \;
find /usr/share/freeswitch -type f -exec chmod 664 {} \;
find /var/www/html -type f -exec chmod 664 {} \;


wait ${!}

cat <<EOT >> /etc/systemd/system/freeswitch.service

[Unit]
Description=FreeSWITCH
Wants=network-online.target
After=syslog.target network-online.target
After=mariadb.service httpd.service

[Service]
Type=forking
User=freeswitch
ExecStartPre=/usr/bin/mkdir -m 0750 -p /run/freeswitch
ExecStartPre=/usr/bin/chown freeswitch:daemon /run/freeswitch
WorkingDirectory=/run/freeswitch
PIDFile=/run/freeswitch/freeswitch.pid
EnvironmentFile=-/etc/sysconfig/freeswitch
ExecStart=/usr/bin/freeswitch -ncwait -nonat $FREESWITCH_PARAMS
ExecReload=/usr/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

EOT


wait ${!}

cat <<EOT >> /etc/sysconfig/freeswitch


FREESWITCH_PARAMS=""


EOT


wait ${!}


systemctl restart freeswitch
wait ${!}


