#!/bin/bash
install_vpn(){
y=$(yum repolist | awk '{print $2}'|sed 's/,//'|sed -n '$p')
if [ $y -eq 0 ];then
echo "请配置yum源"
else
yum -y install libreswan
echo '
conn IDC-PSK-NAT
    rightsubnet=vhost:%priv
    also=IDC-PSK-noNAT

conn IDC-PSK-noNAT
    authby=secret
        ike=3des-sha1;modp1024
        phase2alg=aes256-sha1;modp2048
    pfs=no
    auto=add
    keyingtries=3
    rekey=no
    ikelifetime=8h
    keylife=3h
    type=transport
    left=
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any' > /etc/ipsec.d/myipsec.conf
read -p "请输入本服务器的外网ip" real_ip
sed -in "s/left=/left=$real_ip/" /etc/ipsec.d/myipsec.conf
fi
read -p "输入预共享密钥" pass
echo " $real_ip %any: PSK '$pass'" > /etc/ipsec.d/mypass.secrets
systemctl restart ipsec
if [ -f xl2tpd-1.3.8-2.el7.x86_64.rpm ];then
yum -y install xl2tpd-1.3.8-2.el7.x86_64.rpm
read -p "给予客户端的IP池,格式为192.168.1.1-192.168.1.254" give_ip
sed -i "s/ip range = 192.168.1.128-192.168.1.254/ip range = $give_ip/" /etc/xl2tpd/xl2tpd.conf
sed -i "s/local ip = 192.168.1.99/local ip = $real_ip/" /etc/xl2tpd/xl2tpd.conf
sed -i "s/crtscts/#crtscts/" /etc/ppp/options.xl2tpd
sed -i "s/lock/#lock/" /etc/ppp/options.xl2tpd
echo 'require-mschap-v2' >> /etc/ppp/options.xl2tpd
echo "1" > /proc/sys/net/ipv4/ip_forward
fi
}
add_user(){
read -p "用户名" user
read -p "密码" pass
echo "$user * $pass * " >> /etc/ppp/chap-secrets
systemctl restart ipsec
systemctl restart xl2tpd
}
read -p "请选择:1建立vpn.2新建用户" abc
case $abc in
1)
install_vpn;;
2)
add_user;;
*)
echo bye;;
esac

