#!/usr/bin/bash

# etcd 설치
cd ~
export RELEASE=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest|grep tag_name | cut -d '"' -f 4)
wget https://github.com/etcd-io/etcd/releases/download/${RELEASE}/etcd-${RELEASE}-linux-amd64.tar.gz
tar xf etcd-${RELEASE}-linux-amd64.tar.gz
cd etcd-${RELEASE}-linux-amd64
sudo mv etcd etcdctl etcdutl /usr/local/bin
sudo etcd --version

# ubuntu 사용자가 kubectl 명령 실행 가능하도록 설정
sudo mkdir -p ~ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf ~ubuntu/.kube/config
sudo chown -R ubuntu:ubuntu ~ubuntu/.kube

sudo su - ubuntu
source <(kubectl completion bash); echo "source <(kubectl completion bash)" >> ~/.bashrc 
kubectl get nodes >> /home/ubuntu/kubectl_nodes.log
# NAME     STATUS   ROLES           AGE   VERSION
# master   Ready    control-plane   10m   v1.25.2
# node1    Ready    <none>          84s   v1.25.2
# node2    Ready    <none>          80s   v1.25.2