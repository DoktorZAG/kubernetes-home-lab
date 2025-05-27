#!/bin/bash

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

NODENAME=$(hostname -s)

sudo kubeadm config images pull

# Initialize Kubernetes master node with the desired static IP address (customize CIDR as needed)
sudo kubeadm init --pod-network-cidr=$POD_CIDR --apiserver-advertise-address=$CONTROL_IP --node-name "$NODENAME" --v=5

# Configure kubectl for the current user (root)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Set up kube config for 'vagrant' user
VAGRANT_HOME=$(eval echo ~vagrant)
mkdir -p "$VAGRANT_HOME/.kube"
cp -i /etc/kubernetes/admin.conf "$VAGRANT_HOME/.kube/config"
chown vagrant:vagrant "$VAGRANT_HOME/.kube/config"

# Save Configs to shared /Vagrant location
# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.
config_path="/vagrant/configs"
if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf $config_path/config
touch $config_path/join.sh
chmod +x $config_path/join.sh

kubeadm token create --print-join-command > $config_path/join.sh
