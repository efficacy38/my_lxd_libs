#!/bin/bash
# sudo snap install lxd
# sudo lxd init --auto

# set -x 
# iterate the user's lxc container
for name in jerry branko chofinn angela phoebe angela henry edger toby solomon bak1 bak2 bak3; do
	ipv4=$(echo -e $(lxc info $name | yq '.Ips' | grep eth0 | grep 'inet\\') | cut -f 2)
	ipv6=$(echo -e $(lxc info $name | yq '.Ips' | grep eth0 | grep 'inet6\\' | head -1) | cut -f2)
	echo $name $ipv4 $ipv6
	./updateDDNS.sh $name $ipv4 $ipv6
done

