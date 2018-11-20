#!/bin/bash
yum clean all > /dev/null
y=$(yum repolist | awk '{print $2}'|sed 's/,//'|sed -n '$p')
if [ $y -eq 0 ];then
echo "请配置yum源"
else
yum -y install httpd
yum -y install mariadb mariadb-server mariadb-devel
yum -y install php php-mysql
fi
