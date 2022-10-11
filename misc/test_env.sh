#!/bin/bash
lxc launch ubuntu:20.04 test_curl

for name in jerry branko chofinn angela phoebe angela henry edger toby solomon bak1 bak2 bak3; do 
	# set -x
	lxc exec $name -- /bin/bash -c 'docker rm -f $(docker ps -a -q)'
	lxc exec $name -- docker run -p 80:80 --name test_alive -d --rm nginx
	lxc exec $name -- docker exec -it test_alive sh -c "echo I am $name > /usr/share/nginx/html/index.html"
	lxc exec test_curl -- curl $name.lab.test.ncnu.org
done

lxc launch ubuntu:20.04 -p default -p macvlan test-curl

for name in jerry branko chofinn angela phoebe angela henry edger toby solomon bak1 bak2 bak3; do 
	res=$(lxc exec test-curl -- curl -s $name.lab.test.ncnu.org)
	echo $name $res
done

lxc rm -f test-curl


