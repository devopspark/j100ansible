#!/usr/bin/bash

# docker 엔진 설치
sudo apt update
sudo apt install -y docker.io 
sudo systemctl enable --now docker

# cri-docker 설치
sudo wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.0/cri-dockerd_0.3.0.3-0.ubuntu-bionic_amd64.deb
sudo dpkg -i cri-dockerd_0.3.0.3-0.ubuntu-bionic_amd64.deb
# ls /var/run/cri-dockerd.sock