Vagrant.configure(2) do |config|
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = "1"
        vb.name = "node-project"
    end
    
    config.vm.define "node-project"
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "node-project"
    config.vm.network "private_network", ip: "192.168.33.10"
    config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => false, owner: "www-data", group: "www-data"
    
    config.vm.provision :hostmanager
    config.hostmanager.enabled            = true
    config.hostmanager.manage_host        = true
    config.hostmanager.ignore_private_ip  = false
    config.hostmanager.include_offline    = true
    config.hostmanager.aliases            = "node-project"
    
    config.vm.provision "shell", path: "./vagrant.sh", args: [
        "git curl nginx",
        "lodash",
        "webpack",
        "2048",
        "Asia/Yekaterinburg",
        "node-project"
    ]
    
    config.vm.provision "shell", inline: "service nginx restart", run: "always"
end
