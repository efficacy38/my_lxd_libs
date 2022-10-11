#!/bin/bash
# sudo snap install lxd
# sudo lxd init --auto

# set -x 
lxc profile create macvlan
# change macvlan's nic parent to the real one, that might support macvlan
perl -i -pe "s/parent: .*$/parent: $(ip route show to 0.0.0.0/0 | awk '{print $5}' | head -1)/g" macvlan_profile.txt

# import the macvlan profile
lxc profile edit macvlan < ./macvlan_profile.txt

# how to use it
# lxc launch ubuntu:20.04 -p default -p macvlan <CT name>
