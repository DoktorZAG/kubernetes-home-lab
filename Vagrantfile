require "yaml"
settings = YAML.load_file "settings.yaml"

CONTROL_IP = settings["network"]["control_ip"]
IP_SECTIONS = CONTROL_IP.match(/^([0-9.]+\.)([^.]+)$/)
# First 3 octets including the trailing dot:
IP_NW = IP_SECTIONS.captures[0]
# Last octet excluding all dots:
IP_START = Integer(IP_SECTIONS.captures[1])
NUM_WORKER_NODES = settings["nodes"]["workers"]["count"]

Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: { "IP_NW" => IP_NW, "IP_START" => IP_START, "NUM_WORKER_NODES" => NUM_WORKER_NODES }, inline: <<-SHELL
    echo "$IP_NW$((IP_START)) master-node" >> /etc/hosts
    for i in `seq 1 ${NUM_WORKER_NODES}`; do
      echo "$IP_NW$((IP_START+i)) worker-node0${i}" >> /etc/hosts
    done
  SHELL

  config.vm.box = settings["software"]["box"]
  # config.vm.box_version = settings["software"]["box_version"]
  # config.vm.box_check_update = true
  config.vm.boot_timeout = 300

  config.vm.define "master" do |master|
    # Create a private network with a static IP address within the '10.0.0.0/24' range
    master.vm.network "private_network", ip: CONTROL_IP, netmask: settings["network"]["netmask"]
    master.vm.network "forwarded_port", guest: 6443, host: 6443
	
	master.vm.provider "virtualbox" do |vb|
      vb.name = settings["nodes"]["control"]["name"]
      vb.memory = settings["nodes"]["control"]["memory"]
      vb.cpus = settings["nodes"]["control"]["cpus"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
    end

    master.vm.provision "shell", name: "base-upgrade", path: "scripts/base-upgrade.sh", run: "once"

    master.vm.provision "reload", type: "reload", run: "once"

    master.vm.provision "shell",
    env: {
      "NODE_IP" => CONTROL_IP
    },
	path: "scripts/common.sh"
    
	master.vm.provision "shell",
      env: {
        "CONTROL_IP" => CONTROL_IP,
        "POD_CIDR" => settings["network"]["pod_cidr"],
      },
      path: "scripts/master.sh"
	  master.vm.provision "shell", path: "scripts/master-install-cilium-cli.sh"
  end

  (1..NUM_WORKER_NODES).each do |i|
    NODE_IP = "#{IP_NW}#{IP_START + i}"

    config.vm.define "node0#{i}" do |node|
      node.vm.hostname = settings["nodes"]["workers"]["name-prefix"] + "0#{i}"
      node.vm.network "private_network", ip: NODE_IP, netmask: settings["network"]["netmask"]

      node.vm.provider "virtualbox" do |vb|
        vb.name = settings["nodes"]["workers"]["name-prefix"] + "0#{i}"
        vb.memory = settings["nodes"]["workers"]["memory"]
        vb.cpus = settings["nodes"]["workers"]["cpus"]
        vb.customize ["modifyvm", :id, "--audio", "none"]
        vb.customize ["modifyvm", :id, "--groups", ("/" + settings["cluster_name"])]
      end

      node.vm.provision "shell", name: "base-upgrade", path: "scripts/base-upgrade.sh", run: "once"

      node.vm.provision "reload", type: "reload", run: "once"
    
      node.vm.provision "shell",
      env: {
        "NODE_IP" => NODE_IP
      },
	  path: "scripts/common.sh"

      node.vm.provision "shell",
      env: {
        "NODE_NAME" => settings["nodes"]["workers"]["name-prefix"] + "0#{i}"
      },
      path: "scripts/node.sh"
    end
  end

  # Configure vbguest for Debian/Ubuntu systems
  config.vbguest.installer = VagrantVbguest::Installers::Debian
  config.vbguest.auto_update = true

  # Ensure package list is updated
  config.vbguest.installer_hooks[:before_install] = [
    'sudo apt-get update -qq',
    'sudo apt-get install -y build-essential dkms linux-headers-$(uname -r)'
  ]
end
