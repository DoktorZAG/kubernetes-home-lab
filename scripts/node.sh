#!/bin/bash

config_path="/vagrant/configs"

/bin/bash $config_path/join.sh -v

sudo -i -u vagrant bash <<EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
echo "Node name: $NODE_NAME"
kubectl label node "$NODE_NAME" node-role.kubernetes.io/worker=worker
EOF