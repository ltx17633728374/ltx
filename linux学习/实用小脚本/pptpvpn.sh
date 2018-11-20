#!/bin/bash
install_vpn(){
if [ -f pptpd-1.4.0-2.el7.x86_64.rpm ];then
yum -y install pptpd-1.4.0-2.el7.x86_64.rpm
q=$(rpm -qc pptpd | grep .conf$)
read -p "请输入本机ip" local_ip
echo "localip $local_ip" >> $q
read -p "分配给客户端的地址池,比如192.168.1.1-50" remote_ip
echo "remoteip $remote_ip" >> $q
e=$(rpm -qc pptpd | grep options.pptpd$)
sed -in 's/#ms-dns 10.0.0.1/ms-dns 8.8.8.8/' $e
echo "1" > /proc/sys/net/ipv4/ip_forward
else
echo "请下载软件包"
fi
}
read -p "请选择:1安装pptpvpn.2添加客户" abc
case $abc in
1)
install_vpn;;
2)
read -p "客户端用户名" user
read -p "连接的密码" passwd
echo " $user * $passwd *" >> /etc/ppp/chap-secrets;;
*)
echo "bye"
esac 
