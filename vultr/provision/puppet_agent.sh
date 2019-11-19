#!/bin/bash
set -x
PRIV_IP=$1
PUPPET_SERVER=$2
CERTNAME=$3

# wait until vult is done with its own update
sleep 120

wget -O /tmp/puppetlabs.deb https://apt.puppetlabs.com/puppet6-release-buster.deb
dpkg -i /tmp/puppetlabs.deb
apt-get update
apt-get install -y puppet-agent

cat <<EOT >> /etc/network/interfaces
auto ens7
iface ens7 inet static
    address $PRIV_IP
    netmask 255.255.0.0
    mtu 1450
EOT

ifup ens7

echo "$PUPPET_SERVER puppet" >> /etc/hosts

/opt/puppetlabs/bin/puppet agent -t --server puppet --certname=$CERTNAME --waitforcert 180 || true
