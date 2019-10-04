echo "[agent]
server = zabbix.dexter.com.br
environment = production
runinterval = 60" > /etc/puppetlabs/puppet/puppet.conf
systemctl restart puppet
systemctl enable puppet