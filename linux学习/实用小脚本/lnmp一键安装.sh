#!/bin/bash
menu(){
clear
echo "请确保已经下载了源码包和配置了yum源"
echo "1安装Nginx"
echo "2安装MySQL"
echo "3安装PHP"
echo "4退出"
}
choice(){
 read -p "请选择安装的软件" lnmp
}
install_nginx(){
 useradd -s /sbin/nologin nginx &> /dev/null
 if [ -f nginx-1.12.2.tar.gz ];then
 tar -xf nginx-1.12.2.tar.gz
 cd nginx-1.12.2
 yum -y install gcc pcre-devel openssl-devel make
 ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module
 make
 make install
 ln -s /usr/local/nginx/sbin/nginx /usr/sbin/
 cd ..
 else
 echo "请下载1.12.2版本的源码包"
 fi
}
install_mysql(){
 echo "请确保拥有MySQL的yum源"
 yum -y install mysql-community-* >& /dev/null
 if [ $? -eq 0 ];then
 echo "安装成功"
 else
 echo "安装失败,请配置yum源"
 fi
}
install_php(){
 if [ -f php-fpm-5.4.16-42.el7.x86_64.rpm ];then
 yum -y install php php-fpm-5.4.16-42.el7.x86_64.rpm php php-mysql
 else
 echo "请下载php-fpm包"
fi
}

while :
do
echo "正在缓冲"
sleep 5
menu
choice
case $lnmp in
1)
install_nginx;;
2)
install_mysql;;
3)
install_php;;
4)
exit;;
*)
echo "bye"
esac
done

