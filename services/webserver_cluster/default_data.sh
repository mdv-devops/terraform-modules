#!/bin/bash

echo ------------------------START BOOT STRAPING-----------------------
sudo yum -y update
sudo yum install -y httpd

public_ip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
hostname=`curl http://169.254.169.254/latest/meta-data/hostname`
echo "<html><body bgcolor=white><center><h2><p><font color=red>Server-$hostname powered by Terraform whis public ip-$public_ip greets you<h2><center><body><html>" > /var/www/html/index.html
echo "<p> Default page </p>" >> /var/www/html/index.html
echo "<p> DB address: ${db_address} </p>" >> /var/www/html/index.html
echo "<p> DB port: ${db_port} </p>" >> /var/www/html/index.html
echo "<p> ver-3.0 </p>" >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on

echo -----------------------FINISH BOOT STRAPING-----------------------
