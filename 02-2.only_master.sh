#!/usr/bin/bash

# node 초기화 될때까지 기다림
# watch kubectl get pods -n calico-system
#sudo while [`kubectl get pods -n calico-system | awk '{print $3}' | grep -ie pending -e init`] ; do kubectl get pods -n calico-system >> /home/ubuntu/calico_status.log ; sleep 1; done

kubectl get pods -n calico-system >> /home/ubuntu/calico_status.log
# NAME                                       READY   STATUS    RESTARTS   AGE
# calico-kube-controllers-85666c5b94-927wg   1/1     Running   0          82s
# calico-node-hcnp9                          1/1     Running   0          82s
# calico-typha-f8845f557-cwgmx               1/1     Running   0          83s
# csi-node-driver-l94kh                      2/2     Running   0          40s

# 다시 확인
kubectl get nodes >> /home/ubuntu/kubectl_nodes.log
# NAME     STATUS   ROLES           AGE     VERSION
# master   Ready    control-plane   5m15s   v1.24.8

# Calico Mode 변경- 지왕님 search 도움(고마워요 지왕님)
# https://github.com/projectcalico/calico - release 버전확인후 조절.
sudo curl -L https://github.com/projectcalico/calico/releases/download/v3.24.1/calicoctl-linux-amd64 -o calicoctl
sudo chmod +x calicoctl
sudo mv calicoctl /usr/bin

calicoctl get ippool -o wide >> /home/ubuntu/calico_status.log
# NAME                  CIDR             NAT    IPIPMODE   VXLANMODE     DISABLED   DISABLEBGPEXPORT   SELECTOR   
# default-ipv4-ippool   192.168.0.0/16   true   Never      CrossSubnet   false      false              all()

cat << END > ipipmode.yaml 
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: default-ipv4-ippool
spec:
  blockSize: 26
  cidr: 192.168.0.0/16
  ipipMode: Always
  natOutgoing: true
  nodeSelector: all()
  vxlanMode: Never
END

calicoctl apply -f ipipmode.yaml >> /home/ubuntu/calico_status.log
calicoctl get ippool -o wide >> /home/ubuntu/calico_status.log
# NAME                  CIDR             NAT    IPIPMODE   VXLANMODE   DISABLED   DISABLEBGPEXPORT   SELECTOR   
# default-ipv4-ippool   192.168.0.0/16   true   Always     Never       false      false              all()

# 자동완성 기능
sudo apt-get install bash-completion -y
sudo source <(kubectl completion bash) 
sudo echo "source <(kubectl completion bash)" >> ~/.bashrc 