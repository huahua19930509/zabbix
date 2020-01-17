#!/bin/bash
################################部署zabbix被监控主机################################
read -p '请输入zabbix_server的ip:'  ip
read -p '请输入主机名:'  host
yum -y install gcc make  pcre-devel
tar -xvf /opt/zabbix-3.4.4.tar.gz -C /opt
useradd -s /sbin/nologin zabbix
cd /opt/zabbix-3.4.4
./configure --enable-agent
make && make install


sed -i '69s/# //' /usr/local/etc/zabbix_agentd.conf
sed -i '69s/0/1/' /usr/local/etc/zabbix_agentd.conf
sed -i "93s/127.0.0.1/$ip/" /usr/local/etc/zabbix_agentd.conf
sed -i "134s/127.0.0.1/$ip/" /usr/local/etc/zabbix_agentd.conf
sed -i "145s/Zabbix server/$host/" /usr/local/etc/zabbix_agentd.conf
sed -i '264s/# //' /usr/local/etc/zabbix_agentd.conf
sed -i '280s/# //' /usr/local/etc/zabbix_agentd.conf
sed -i '280s/0/1/' /usr/local/etc/zabbix_agentd.conf

zabbix_agentd

cd /opt/zabbix-3.4.4/misc/init.d/fedora/core
cp zabbix_agentd /etc/init.d/

