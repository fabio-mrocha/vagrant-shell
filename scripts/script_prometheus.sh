sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-2.el7.noarch.rpm
yum install zabbix-agent -y

sed -i 's:Server=127.0.0.1:Server=zabbix.dexter.com.br:' /etc/zabbix/zabbix_agentd.conf
sed -i 's:ServerActive=127.0.0.1:ServerActive=zabbix.dexter.com.br:' /etc/zabbix/zabbix_agentd.conf
sed -i 's:Hostname=Zabbix server:Hostname=prometheus:' /etc/zabbix/zabbix_agentd.conf

systemctl enable zabbix-agent
systemctl restart zabbix-agent