# INSTALAÇÃO ZABBIX
wget https://repo.zabbix.com/zabbix/4.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.2-2+bionic_all.deb
dpkg -i zabbix-release_4.2-2+bionic_all.deb
apt update
apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent jq zabbix-get

# INSTALAÇÃO PUPPET SERVER
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
dpkg -i puppet6-release-bionic.deb
apt update
apt -y install puppetserver

# CONFIGURANDO ZABBIX
mysql -u root -e "create database zabbix character set utf8 collate utf8_bin";
mysql -u root -e "grant all privileges on zabbix.* to zabbix@localhost identified by '4linux'";
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p4linux zabbix
sed -i 's:# DBPassword=:DBPassword=4linux:' /etc/zabbix/zabbix_server.conf
sed -i 's:# php_value date.timezone Europe/Riga:php_value date.timezone America/Sao_Paulo:' /etc/zabbix/apache.conf

# CONFIGURANDO ZABBIX AGENTE
sed -i 's:# AllowRoot=0:AllowRoot=1:' /etc/zabbix/zabbix_agentd.conf
echo "UserParameter=usuarios,wc -l /etc/passwd | awk '{print $1}'
UserParameter=lld.services,/usr/local/bin/lld.pl" >> /etc/zabbix/zabbix_agentd.conf
sudo cp /vagrant/files/lld.pl /usr/local/bin/ && chmod +x /usr/local/bin/lld.pl

# ADICIONANDO MODULO DE INSTALAÇÃO E GERENCIA DO ZABBIX
/opt/puppetlabs/bin/puppet module install puppet-zabbix --version 6.4.2

# CONFIGURAÇÕES QUE SERÃO ENVIADAS AOS AGENTES
echo "node 'default' {
 class { 'zabbix::agent':
  server => 'zabbix.dexter.com.br',
  serveractive => 'zabbix.dexter.com.br',
  hostmetadataitem => 'system.uname',
 }
}" >> /etc/puppetlabs/code/environments/production/manifests/site.pp

systemctl restart zabbix-server zabbix-agent apache2 puppetserver
systemctl enable zabbix-server zabbix-agent apache2 puppetserver