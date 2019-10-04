cd /root
yum install epel-release python unzip git wget vim java-1.8.0-openjdk yum-utils device-mapper-persistent-data lvm2 puppet-agent -y
curl -O http://ftp.unicamp.br/pub/apache//jmeter/binaries/apache-jmeter-5.1.zip
unzip apache-jmeter-5.1.zip
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
echo "[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" > /etc/yum.repos.d/mongodb-org-3.6.repo
yum install python-pip docker-ce jenkins mongodb-org-shell.x86_64 -y
echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
systemctl enable jenkins docker puppet
systemctl start jenkins docker
systemctl restart puppet