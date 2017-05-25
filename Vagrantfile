require 'yaml'
yaml = YAML.load_file File.join(File.dirname(__FILE__), 'vagrant.yaml')

Vagrant.configure(2) do |config|
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = yaml['vb']['memory']
        vb.cpus = yaml['vb']['cpus']
        vb.name = yaml['vb']['name']
    end

    config.vm.define yaml['vb']['name'] {}
    config.vm.box = yaml['config']['vm']['box']
    config.vm.hostname = yaml['config']['vm']['hostname']
    config.vm.network "private_network", ip: yaml['config']['vm']['ip']
    config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => false, owner: "www-data", group: "www-data"

    config.vm.provision :hostmanager
    config.hostmanager.enabled            = true
    config.hostmanager.manage_host        = true
    config.hostmanager.ignore_private_ip  = false
    config.hostmanager.include_offline    = true
    config.hostmanager.aliases            = yaml['config']['hostmanager']['aliases']

    config.vm.provision "shell", path: "./vagrant.sh", args: [
        yaml['vagrantsh']['packages'].join(" "),
        yaml['vagrantsh']['npm']['save'].join(" "),
        yaml['vagrantsh']['npm']['savedev'].join(" "),
        yaml['vagrantsh']['swapsize'],
        yaml['vagrantsh']['timezone'],
        yaml['vb']['name']
    ]

    config.vm.provision "shell", inline: "service nginx restart", run: "always"
    config.vm.provision "shell", inline: "cd /var/www && node index.js", run: "always"
end
