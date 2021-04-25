Vagrant.configure("2") do |config|

# Cluster Nodes
  cluster_nodes=3

    (1..cluster_nodes).each do |i|
      config.vm.define "zookeeper-#{i}" do |node|
        node.vm.box = "centos/7"
        node.vm.hostname  = "zookeeper#{i}"
        node.vm.network :private_network, ip: "192.168.56.10#{i}"
        #node.vm.provision :hosts, :sync_hosts => true
      end
  end
  # Setting CPU and Memory for All machines
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus =  1
  
  # disable auto update for vbguest plugin update
  config.vbguest.auto_update = false
  end

# SSH config to use your local ssh key for auth instead of username/password
    config.ssh.insert_key = false
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
end