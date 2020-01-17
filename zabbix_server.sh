#!/bin/bash
ip=192.168.4.101
host=web-t2
#########################部署LNMP平台##############################
ng=/usr/local/nginx/conf/nginx.conf
sysng=/usr/lib/systemd/system
yum -y install gcc make pcre-devel zlib-devel openssl-devel  #zlib-devel 压缩文件
tar -xvf /opt/mysql-5.7.17.tar -C /opt
cd /opt
yum -y install mysql-community-*.rpm
tar -xvf /opt/nginx-1.15.8.tar.gz -C /opt
#sed -i '13s/1.15.8/2.2.3/' /opt/nginx-1.15.8/src/core/nginx.h
#sed -i '14s/nginx/Apache/' /opt/nginx-1.15.8/src/core/nginx.h #隐藏版本
cd /opt/nginx-1.15.8
useradd -s /sbin/nologin nginx
./configure   --user=nginx --with-http_ssl_module  --with-http_stub_status_module 
make && make install
yum -y install php php-fpm php-mysql 
sed -i '65,68s/#//' $ng
sed -i '70,71s/#//' $ng 
sed -i '70s/fastcgi.*/fastcgi.conf;/' $ng  #部署动态页面
sed -i '65i  fastcgi_buffers 8 16k;\nfastcgi_buffer_size 32k;\nfastcgi_connect_timeout 300;\nfastcgi_send_timeout 300;\nfastcgi_read_timeout 300;' $ng #开启fastcgi缓存,加速PHP脚本的执行速度.
systemctl daemon-reload
systemctl enable php-fpm  mysqld nginx.service  #需编写开机自启/usr/lib/systemd/system/nginx.service
systemctl restart php-fpm  mysqld nginx.service
ss -nlutp | grep :80 && echo 'nginx启动成功' || echo 'nginx启动失败'
ss -nlutp | grep :3306 && echo 'mysql启动成功' || echo 'mysql启动失败'
ss -nlutp | grep :9000 && echo 'php-fpm启动成功' || echo 'php-fpm启动失败'
###########################部署zabbix主服务器##############################
sed -i '5a validate_password_policy=0\nvalidate_password_length=6' /etc/my.cnf
systemctl restart  mysqld
echo '打开脚本,实现zabbix配置,并取消后面注释'
#################################半自动创建zabbix数据仓库及用户#######################################
#SQL=$(grep -i password /var/log/mysqld.log | awk 'NR==1{print $NF}') #将原始密码过滤出来            #
#mysql -uroot -p$SQL -e 'Alter user root@'localhost' identified by '123qqq...A';'                    #
#mysql -uroot -p'123qqq...A' -e 'create database zabbix character set utf8;'                         #
#mysql -uroot -p'123qqq...A' -e 'grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';'#
#进入数据库后配置                                                                                    #
######################################################################################################
#tar -xf /opt/zabbix-3.4.4.tar.gz -C /opt
#yum -y install  net-snmp-devel curl-devel libevent-devel
#cd /opt/zabbix-3.4.4
#./configure  --enable-server --enable-proxy --enable-agent \
#             --with-mysql=/usr/bin/mysql_config \
#             --with-net-snmp --with-libcurl
#make && make install
#cd  /opt/zabbix-3.4.4/database/mysql/
#mysql -uzabbix -pzabbix zabbix < schema.sql
#mysql -uzabbix -pzabbix zabbix < images.sql
#mysql -uzabbix -pzabbix zabbix < data.sql
#
#cd /opt/zabbix-3.4.4/frontends/php/
#cp -r ./* /usr/local/nginx/html/
#chmod -R 777 /usr/local/nginx/html/*
#
#useradd -s /sbin/nologin zabbix
#zs=/usr/local/etc/zabbix_server.conf
#sed -i '85s/.*/DBHost=localhost/' $zs
#sed -i '95s/.*/DBName=zabbix/' $zs
#sed -i '111s/.*/DBUser=zabbix/' $zs
#sed -i '119s/.*/DBPassword=zabbix/' $zs
#zabbix_server
#
#za=/usr/local/etc/zabbix_agentd.conf
#sed -i "93s/127.0.0.1/$ip/" $za
#sed -i "134s/127.0.0.1/$ip/" $za
#sed -i "145s/Zabbix server/$host/" $za
#sed -i '264s/# //' $za
#sed -i '280s/# //' $za
#sed -i '280s/0/1/' $za
#zabbix_agentd
#
#yum -y install php-gd php-xml php-bcmath php-mbstring
#sed -i '384s/30/300/' /etc/php.ini
#sed -i '394s/60/300/' /etc/php.ini
#sed -i '672s/8/32/' /etc/php.ini
#sed -i '878s/;//' /etc/php.ini
#sed -i '878s/=/= Asia\/Shanghai/' /etc/php.ini
#systemctl restart php-fpm
#
#ss -nlutp | grep :10051 && echo -e "\033[030;1mserver启动成功\033[0m" || echo -e "\033[031;1mserver启动失败\033[0m"
#ss -nlutp | grep :10050 && echo -e "\033[030;1magentd启动成功\033[0m" || echo -e "\033[031;1magentd启动失败\033[0m"


#yum -y install google-noto-sans-simplified-chinese-fonts.noarch  #中文支持
# firefox http://192.168.4.60/index.php  
