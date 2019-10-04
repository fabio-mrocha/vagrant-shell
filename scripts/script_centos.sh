sudo rpm -Uvh https://yum.puppet.com/puppet5/el/7/x86_64/puppet5-release-5.0.0-7.el7.noarch.rpm
yum install vim wget python git unzip epel-release puppet-agent -y
systemctl restart puppet
systemctl enable puppet