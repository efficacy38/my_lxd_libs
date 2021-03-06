#!/bin/bash
# sudo snap install lxd
# sudo lxd init --auto

# set -x 
lxc profile create macvlan
# change macvlan's nic parent to the real one, that might support macvlan
perl -i -pe "s/parent: .*$/parent: $(ip route show to 0.0.0.0/0 | awk '{print $5}' | head -1)/g" macvlan_profile.txt

# import the macvlan profile
lxc profile edit macvlan < ./macvlan_profile.txt

KEY='./ddns.key'
NS='ns1.lab.test.ncnu.org'
DOMAIN='lab.test.ncnu.org'
ZONE='lab.test.ncnu.org'
# change dns setting
changeRecord(){
	local user=$1
	local subDom="$user.$DOMAIN"
	local IP=""
	nsupdate -k $KEY -v <<- EOF
	server $NS
	zone $ZONE
	update delete $DOMAIN A
	update add $DOMAIN 30 A IP
	send
EOF
}

# iterate the user's lxc container
for name in jerry branko chofinn angela phoebe angela henry edger toby solomon bak1 bak2 bak3; do
    lxc rm -f $name
    lxc profile create $name
    lxc profile edit $name <<-EOF
    config:
      security.nesting: "true"
      security.privileged: "true"
      security.syscalls.intercept.mknod: "true"
      security.syscalls.intercept.setxattr: "true"

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

    lxc launch ubuntu:20.04 -p default -p $name -p macvlan $name &
done

