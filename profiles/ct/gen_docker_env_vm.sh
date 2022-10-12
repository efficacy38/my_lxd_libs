#!/bin/bash

lxc profile create docker-vm
export name=efficacy38
lxc profile edit docker-vm <<-EOF
config:
  user.user-data: |
    #cloud-config
    ssh_pwauth: True
    users:
      - default
      - name: ${name}
        gecos: ${name}
        primary_group: ${name}
        groups: [ ${name}, sudo, docker ]
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: False
        shell: /bin/bash
        plain_text_passwd: 'test'
    apt:
      sources:
        source1:
          source: deb [arch=amd64] https://download.docker.com/linux/ubuntu \$RELEASE stable
          keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
          # keyserver: https://download.docker.com/linux/ubuntu/gpg
    packages:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-compose
    # runcmd:
      # - apt-get install -y docker-compose
EOF

# how to use it
# lxc launch ubuntu:20.04 -p default -p macvlan -p docker-vm --vm <VM name>
