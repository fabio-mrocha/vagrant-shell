# -*- mode: ruby -*-
# vi: set ft=ruby  :

machines525 = {
  "compliance" => {"memory" => "1024", "cpu" => "2", "ip" => "20", "image" => "ubuntu/bionic64"},
  "container" => {"memory" => "1536", "cpu" => "1", "ip" => "30", "image" => "centos/7"},
  "scm" => {"memory" => "256", "cpu" => "1", "ip" => "40", "image" => "debian/buster64"},
  "log" => {"memory" => "2048", "cpu" => "1", "ip" => "50", "image" => "ubuntu/bionic64"},
  "automation" => {"memory" => "1536", "cpu" => "2", "ip" => "10", "image" => "centos/7"}
}

machines528 = {
  "zabbix" => {"memory" => "4096", "cpu" => "1", "ip" => "10", "image" => "ubuntu/bionic64"},
  "graylog" => {"memory" => "4096", "cpu" => "2", "ip" => "11", "image" => "ubuntu/bionic64"},
  "prometheus" => {"memory" => "2048", "cpu" => "1", "ip" => "12", "image" => "centos/7"},
  "4flix" => {"memory" => "2048", "cpu" => "1", "ip" => "13", "image" => "centos/7"},
}

Vagrant.configure("2") do |config|

  config.vm.box_check_update = false
  machines525.each do |name, conf|
    config.vm.define "#{name}" do |machine525|
	iscsi525 = 'D:\VirtualBox\VMs\525-InfraAgil\automation\iscsi525.vdi'
      machine525.vm.box = "#{conf["image"]}"
      machine525.vm.hostname = "#{name}.4labs.example"
      machine525.vm.network "private_network", ip: "10.5.25.#{conf["ip"]}"
      machine525.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.customize ["modifyvm", :id, "--groups", "/525-InfraAgil"]
        if name == "automation" and not File.file?(iscsi525)
          vb.customize ['createhd', '--filename', iscsi525, '--size', 20 * 1024]
          vb.customize ['storagectl', :id, '--name', 'SATA Controller', '--add', 'sata']
          vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', iscsi525]
        end
      end
        if "#{conf["image"]}" == "ubuntu/bionic64"
          machine525.vm.provision "shell", inline: "apt install python -y"
          machine525.vm.provision "shell", inline: "echo '#{name}.4labs.example' > /etc/hostname"
          machine525.vm.provision "shell", inline: "hostnamectl set-hostname #{name}.4labs.example"
        end
        if "#{conf["image"]}" == "debian/buster64"
          machine525.vm.provision "shell", inline: "echo '#{name}.4labs.example' > /etc/hostname"
          machine525.vm.provision "shell", inline: "hostnamectl set-hostname #{name}.4labs.example"
        end
	  machine525.vm.provision "shell", path: "./scripts/script.sh"
    end
  end
  
  machines528.each do |name, conf|
    config.vm.define "#{name}" do |machine528|
	  machine528.vm.synced_folder ".", "/vagrant", disabled: true
      machine528.vm.box = "#{conf["image"]}"
      machine528.vm.hostname = "#{name}"
      machine528.vm.network "private_network", ip: "192.168.99.#{conf["ip"]}", dns: "8.8.8.8"
      machine528.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.customize ["modifyvm", :id, "--groups", "/528-CM"]
      end
        if "#{conf["image"]}" == "ubuntu/bionic64"
			machine528.vm.provision "shell", inline: "apt update && apt install python wget vim unzip -y"
        end
        if "#{conf["image"]}" == "centos/7"
			machine528.vm.provision "shell", path: "./scripts/script_centos.sh"
        end
		if name == "zabbix"
			machine528.vm.provision "shell", path: "./scripts/script_zabbix.sh"
		end
		if name == "prometheus"
			machine528.vm.provision "shell", path: "./scripts/script_prometheus.sh"
		end
		if name == "graylog"
			machine528.vm.provision "shell", inline: "wget https://apt.puppetlabs.com/puppet-release-bionic.deb && sudo dpkg -i puppet-release-bionic.deb"
			machine528.vm.provision "shell", inline: "apt update && apt install snmpd puppet-agent -y"
			machine528.vm.provision "shell", inline: "systemctl restart puppet snmpd && systemctl enable puppet snmpd"
		end
		if name != "zabbix"
			machine528.vm.provision "shell", path: "./scripts/script_puppet.sh"
		end
		if name == "4flix"
			machine528.vm.provision "shell", path: "./scripts/script_4flix.sh"
		end
		machine528.vm.provision "shell", path: "./scripts/script_key.sh"
    end
  end
end