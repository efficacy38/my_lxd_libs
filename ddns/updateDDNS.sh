#!/bin/bash
KEY='./ddns.key'
NS='ns1.lab.test.ncnu.org'
DOMAIN='lab.test.ncnu.org'
ZONE='lab.test.ncnu.org'
# change dns setting
# use `changeRecord sub_domain IP`
changeRecord(){
	local user=$1
	local subDom="$user.$DOMAIN"
	local IP="$2"
	nsupdate -k $KEY -v <<- EOF
	server $NS
	zone $ZONE
	update delete $subDom A
	update add $subDom 30 A $IP
	send
EOF
}

changeRecord $@
