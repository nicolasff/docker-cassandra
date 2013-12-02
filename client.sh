#!/bin/bash

source install/common.sh

check_usage $# 2 "Usage: $0 VERSION CMD [ARGS...]\nCreates a container that is connected to the Cassandra cluster, and run a command there"

BRIDGE=br1
VERSION=$1

test_image $VERSION

# We want to start the client containers from cass254, with decreasing IDs
id=254
while true; do
	hostname="cass$id"
	ip=192.168.100.$id
	available=1

	# echo "Checking if hostname $hostname is available..."

	cids=$(sudo docker ps | grep -w run-command | awk '{print $1}')
	for client_cid in $cids; do
		client_hostname=$(sudo docker inspect $client_cid | grep -w Hostname | sed -E -e 's/.*(cass[0-9]+).*/\1/g')
		# echo "Checking hostname of container $client_cid: $client_hostname"
		if [[ "$hostname" == "$client_hostname" ]]; then
			available=0
		fi
	done

	if [[ $id == 100 ]]; then
		echo "Could not find a hostname for this client"
		exit 1
	fi

	if [[ $available == 1 ]]; then
		break
	else
		id=$(($id-1))
	fi
done

# start container
shift # remove version number
cid=$(sudo docker run -i -d -dns 127.0.0.1 -h $hostname -t cassandra:$VERSION /usr/bin/run-command $@)

# Add network interface
sleep 0.5
sudo pipework $BRIDGE $cid $ip/24

sudo docker attach $cid
