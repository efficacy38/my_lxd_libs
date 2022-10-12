#!/bin/bash

flavors=(small medium large)
for flavor in ${flavors[@]}; do
    lxc profile create $flavor
    lxc profile edit $flavor < $flavor.yaml
done

# how to use it
# lxc launch ubuntu:20.04 -p default -p macvlan -p docker-ct <CT name>
