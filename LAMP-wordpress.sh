#!/bin/bash

#This will change you to root and take you to root user's home directory
sudo su
 cd

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
              yum update -y

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

#These will be default questions from the mysql
                          mysql_secure_installation

#This will ask questions about database, user, password
                        read -p "Enter a database name " dbname
                       read -p "Press enter and provide your root user's password"
                      mysql -u root -p "$rootpassword" -e "CREATE DATABASE $dbname "
                     read -p "Enter database user name :" dbuser
                    read -p "Enter password for the user $dbuser " dbuserpassword
                   read -p "Press enter and provide your root user's password one more time"
                  mysql -u root -p"$rootpassword" -e "GRANT ALL on $dbname.* to $dbuser identified by '$dbuserpassword' "
#This will sync your database information to your wordpress (database establishment)
                  sed -i "/DB_NAME/s/'[^']*'/'$dbname'/2" /var/www/html/wp-config.php
                 sed -i "/DB_USER/s/'[^']*'/'$dbuser'/2" /var/www/html/wp-config.php
                sed -i "/DB_PASSWORD/s/'[^']*'/'$dbuserpassword'/2" /var/www/html/wp-config.php
#This will start apache and mariadb
               systemctl enable httpd
              systemctl restart httpd
             systemctl enable mariadb
            systemctl restart mariadb
