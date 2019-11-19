#!/bin/bash
PRIV_IP=$1

# wait until vult is done with its own update
sleep 120

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common git
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

cat <<EOT >> /etc/network/interfaces
auto ens7
iface ens7 inet static
    address $PRIV_IP
    netmask 255.255.0.0
    mtu 1450
EOT

ifup ens7

cd /opt
git clone https://github.com/kavehmz/kubeadm-tour-puppet.git

mkdir -p mkdir -p /opt/puppet/ssl
docker run -d --rm --name puppet -p $PRIV_IP:8140:8140 -v /opt/puppet/ssl:/etc/puppetlabs/puppet/ssl -v /opt/kubeadm-tour-puppet/production:/etc/puppetlabs/code/environments/production  --hostname puppet puppet/puppetserver:6.2.1
