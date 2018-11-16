#!/bin/bash
vip=192.168.4.15
ip_1=192.168.4.100
ip_2=192.168.4.200
while :
do
sleep 2
 for i in $ip_1 $ip_2
 do
 curl http://$i &> /dev/null
  if [ $? -ne 0 ];then
   ipvsadm -Ln | grep -q $i && ipvsadm -d -t $vip -r $i
#服务挂掉时,把web从集群删除
  fi
 done
 for i in $ip_1 $ip_2
 do
 curl http://$i &> /dev/null
  if [ $? -eq 0 ];then
  ipvsadm -Ln | grep -q $i || ipvsadm -a -t 192.168.4.15:80 -r $i -g
#服务修好时把web加入集群
  fi
 done
done
