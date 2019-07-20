#!/bin/bash
#These lines are gonna install apache, start apache, and enable apache
yum install httpd -y
systemctl start httpd
systemctl enable

#These will open th HTTP and HTPPDS ports in the firewall.
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

#These lines are gonna install mariadb and server itself
yum -y install mariadb-server mariadb
systemctl start mariadb.service
systemctl enable mariadb.service

#This will add Remi CentOS repo
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum update

#These lines are gonna install PhP v70 because Wordpress started supporting php version +5.6
yum-config-manager --enable remi-php70
yum -y install php php-opcache

#These lines are gonna install php modules that are required by CMS Systems like Wordpress, Joomla etc
yum -y install php-mysqlnd php-pdo
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel

#This will install wordpress tar file from the wordpress site and unzip it
yum install wget -y
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz


#These lines are gonna move your wordpress file from the home directory to /var/www/hmtl and give a right file permission to the folder
rsync -avP ~/wordpress/ /var/www/html/
chown -R apache:apache /var/www/html/*

#These lines are gonna copy your wordpress's configuration file
cd /var/www/html
cp wp-config-sample.php wp-config.php
