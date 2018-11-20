#!/bin/bash
lsmod | grep ip_gre >/dev/null
if [ $? -ne 0 ];then
modprobe ip_gre
fi
read -p "你的ip" q
read -p "对方ip" w
ip tunnel add tun0 mode gre remote $w local $q
ip link set tun0 up
read -p "你想设置的隧道ip" a
read -p "对方的隧道ip" s
ip addr add $a peer $s dev tun0
echo "1" > /proc/sys/net/ipv4/ip_forward
n=$(ip a s | grep tun0 | sed -n '$p')
echo "你现在可以用$n这个通道进行通信"
