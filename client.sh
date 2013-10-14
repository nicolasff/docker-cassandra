#!/bin/bash

if [[ -z $1 ]]; then
	echo "Usage: $0 CMD [ARGS...]"
	echo "Creates a container that is connected to the Cassandra cluster, and run a command there"
	exit 1
fi

BRIDGE=br1
VERSION=1.2.10

id=254
hostname="cass$id"
ip=192.168.100.$id

# start container
cid=$(sudo docker run -i -d -dns 127.0.0.1 -h $hostname -t cassandra:$VERSION /usr/bin/run-command $@)

# Add network interface
sleep 0.5
sudo pipework $BRIDGE $cid $ip/24

sudo docker attach $cid
