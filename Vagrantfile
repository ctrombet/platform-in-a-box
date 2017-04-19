VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos/7"
  config.vm.hostname = "platform"
  config.vm.synced_folder "./code", "/vagrant", owner: "vagrant", group: "vagrant", type: "virtualbox"
  config.vm.network :private_network, ip: "192.168.58.111"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.network "forwarded_port", guest: 9092, host: 9092
  config.vm.provision "shell", path: "script.sh"

  config.vm.provider "virtualbox" do |v|
     v.memory = 1024
  end

end
