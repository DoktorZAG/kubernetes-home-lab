# Kubernetes Home Lab Cluster

This project sets up a **multi-node Kubernetes cluster** on your local machine using **Vagrant**, **VirtualBox**, and **Ubuntu VMs**. It provisions a control-plane node and one or more worker nodes, installs Kubernetes with `kubeadm`, and deploys **Cilium** as the CNI (Container Network Interface) using its CLI installer.

## ✨ Features

- Vagrant-based reproducible setup
- Ubuntu Linux base image
- Automatic setup of:
    - `kubeadm`, `kubelet`, `kubectl`
    - `containerd` as container runtime
    - Helm
    - Cilium CNI
- Designed for local Kubernetes learning, CNI testing, and home lab scenarios

## 🛠️ Prerequisites

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- 8 GB+ RAM and 4 CPUs (recommended)
- Internet connection (for package and image download)

## 🚀 Getting Started

```bash
git clone https://github.com/yourusername/k8s-homelab-cluster.git
cd k8s-homelab-cluster
vagrant up
```

This will:

* Spin up a control-plane VM
* Initialize Kubernetes using `kubeadm`
* Configure kubectl for the `vagrant` user
* Install Cilium as CNI
* Spin up worker nodes and join them to the cluster

## 🧹 Customization

Adjust the following directly in `Vagrantfile`/`settings.yaml`:

* Number of worker nodes
* VM resources (RAM, CPU)
* Static IPs for nodes
* Pod CIDR or cluster CIDR range

## 📋 Useful Commands

SSH into VMs:

```bash
vagrant ssh master
vagrant ssh worker1
```

Use `kubectl` from within the `master` or `worker` VM:

```bash
kubectl get nodes
kubectl get pods -A
```

## 🔁 Reset Cluster

```bash
vagrant destroy -f
vagrant up
```

## 🪲 Troubleshooting

* Ensure `VirtualBox` is installed and running
* If nodes fail to join, inspect `/vagrant/configs/join.sh` on the master node
* Check logs: `journalctl -xeu kubelet` or `sudo systemctl status containerd`
