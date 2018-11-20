#!/bin/bash
install_inodi(){
if [ -f inotify-tools-3.13.tar.gz ];then
 tar -xf inotify-tools-3.13.tar.gz 
 cd inotify-tools-3.13
 yum -y install make gcc
 ./configure
 make && make install
else
echo "请下载inotify源码包"
fi
}
read -p "选择:1安装监控.2添加目录 " abc
case $abc in
1)
install_inodi;;
2)
read -p "输入你要监控的目录" dir
read -p "输入你要远程同步的主机和目录,比如root@192.168.1.1:/root/" dir_ip
echo "监控脚本执行中,请勿关闭终端"
while inotifywait -rqq $dir/ 
do 
rsync -az --delete $dir $dir_ip 
done;;

*)
echo bye;;
esac
