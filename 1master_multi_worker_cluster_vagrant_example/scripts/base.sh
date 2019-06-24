#!/bin/bash

cat <<END
Executing ${0}
================================================================================
    Installing Tools and EPEL REPO
      - epel-release
      - wget
      - ntp
      - jq
      - net-tools
      - bind-utils
      - moreutils
================================================================================

END

yum install -y epel-release wget ntp jq net-tools bind-utils moreutils tmux tree lvm2

getenforce | grep Disabled || setenforce 0
echo "SELINUX=disabled" > /etc/sysconfig/selinux

sed -i '/swap/d' /etc/fstab
swapoff --a

cat <<EOF >  /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 
systemctl restart sshd \ && systemctl stop firewalld \ && systemctl disable firewalld

cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
timedatectl set-timezone Asia/Seoul

echo "nameserver 8.8.8.8">/etc/resolv.conf
cat /etc/resolv.conf

systemctl start ntpd
systemctl enable ntpd

