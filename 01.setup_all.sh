#!/usr/bin/bash

# Configure the needrestart.conf file {kernelhints, restart}
sudo sed -i s/'\#\$nrconf{kernelhints} = -1;'/'\$nrconf{kernelhints} = 0;'/g /etc/needrestart/needrestart.conf
sudo sed -i s/'\#\$nrconf{restart} = \x27i\x27;'/'\$nrconf{restart} = \x27l\x27;'/g /etc/needrestart/needrestart.conf

# Load modules(overlay, br_netfilter)
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup system parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Install packages in all nodes.
# Install cri-docker
sudo wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.0/cri-dockerd_0.3.0.3-0.ubuntu-bionic_amd64.deb
sudo dpkg -i cri-dockerd_0.3.0.3-0.ubuntu-bionic_amd64.deb
# ls /var/run/cri-dockerd.sock

# Install kubeadm, kubelet, kubectl
# Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl

#Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg \
    https://packages.cloud.google.com/apt/doc/apt-key.gpg

#Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
    https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt update
sudo apt install -y kubelet=1.26.0-00 kubeadm=1.26.0-00 kubectl=1.26.0-00
sudo apt-mark hold kubelet kubeadm kubectl
