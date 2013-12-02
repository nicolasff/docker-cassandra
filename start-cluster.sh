#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <VERSION> <NUMBER OF NODES>"
	exit 1
fi
VERSION=$1
NODES=$2
BRIDGE=br1

for id in $(seq 1 $NODES); do

	echo "Starting node $id"
	hostname="cass$id"
	ip=192.168.100.$id

	# start container
	cid=$(sudo docker run -d -dns 127.0.0.1 -h $hostname -t cassandra:$VERSION /usr/bin/start-cassandra)

	# Add network interface
	sleep 1
	sudo pipework $BRIDGE $cid $ip/24

done
