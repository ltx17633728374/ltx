#!/bin/bash
cd `dirname $0`
python_ver=$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+$"|tail -1)
eval $(ps -ef | grep "[0-9] ${python_ver} local\\.py m" | awk '{print "kill "$2}')
ulimit -n 512000
nohup ${python_ver} /opt/shadowsocksr/shadowsocks/local.py -c /opt/shadowsocksr/user_config.json m>> ~/nohup.txt 2>&1 &
