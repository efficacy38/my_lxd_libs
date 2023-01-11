#!/bin/bash
ls *.profile.txt | awk 'match($0, /(.*)\.profile\.txt/, m) {print m[1]}' | xargs -n1 lxc profile create
ls *.profile.txt | awk 'match($0, /(.*)\.profile\.txt/, m) {print m[1]}' | xargs -I{} -n1 bash -c "lxc profile edit {} < {}.profile.txt"

