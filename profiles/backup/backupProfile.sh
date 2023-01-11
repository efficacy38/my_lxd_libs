#!/bin/bash

set -e
set -x

function saveProfile2Dir () {
    echo $0 $1
    lxc profile show $1 > $1.profile.txt
}

export -f saveProfile2Dir

lxc profile list -f json | jq -r '.[].name' | xargs -n1 -I {} bash -c 'saveProfile2Dir "$@"' _ {}
