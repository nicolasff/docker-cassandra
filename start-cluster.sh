#!/bin/bash

source install/common.sh

check_usage $# 2 "Usage: $0 <VERSION> <NUMBER OF NODES>"

VERSION=$1
NODES=$2
BRIDGE=br1

test_image $VERSION

for id in $(seq 1 $NODES); do

	echo "Starting node $id"
	hostname="cass$id"
	ip=192.168.100.$id

	# start container
	if [[ $id == 1 ]]; then
		ports="-p 9160:9160 -p 9042:9042"
	else
		ports=""
	fi
	cid=$(sudo docker run -d --dns 127.0.0.1 -h $hostname $ports -t cassandra:$VERSION /usr/bin/start-cassandra)

	# Add network interface
	sleep 1
	sudo pipework $BRIDGE $cid $ip/24

done
