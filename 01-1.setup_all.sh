#!/usr/bin/bash

# Configure the needrestart.conf file {kernelhints, restart}
sudo sed -i s/'\#\$nrconf{kernelhints} = -1;'/'\$nrconf{kernelhints} = 0;'/g /etc/needrestart/needrestart.conf
sudo sed -i s/'\#\$nrconf{restart} = \x27i\x27;'/'\$nrconf{restart} = \x27l\x27;'/g /etc/needrestart/needrestart.conf

# br_netfilter 모듈을 로드
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# bridge taffic 보게 커널 파라메터 수정
# 필요한 sysctl 파라미터를 /etc/sysctl.d/conf 파일에 설정하면, 재부팅 후에도 값이 유지된다.

# Setup system parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system