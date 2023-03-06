#!/usr/bin/bash

sudo -i
# etcd 설치
export RELEASE=$(curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest|grep tag_name | cut -d '"' -f 4)
wget https://github.com/etcd-io/etcd/releases/download/${RELEASE}/etcd-${RELEASE}-linux-amd64.tar.gz
tar xf etcd-${RELEASE}-linux-amd64.tar.gz
cd etcd-${RELEASE}-linux-amd64
mv etcd etcdctl etcdutl /usr/local/bin/
etcdctl version  >> etcd_util.log
etcd --version  >> etcd_util.log

source <(kubectl completion bash); echo "source <(kubectl completion bash)" >> ~/.bashrc 
kubectl get nodes >> /home/ubuntu/kubectl_nodes.log
# NAME     STATUS   ROLES           AGE   VERSION
# master   Ready    control-plane   10m   v1.25.2
# node1    Ready    <none>          84s   v1.25.2
# node2    Ready    <none>          80s   v1.25.2