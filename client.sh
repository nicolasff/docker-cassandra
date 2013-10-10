#!/bin/bash

BRIDGE=br1
VERSION=1.2.10

id=254
hostname="cass$id"
ip=192.168.100.$id

# start container
cid=$(sudo docker run -i -d -dns 127.0.0.1 -h $hostname -t cassandra:$VERSION /usr/bin/start-shell)

# Add network interface
sleep 1
sudo pipework $BRIDGE $cid $ip/24

sudo docker attach $cid

# strace -s 256 -v -f ./nodetool -h cass1 info 2>&1 | grep -Ew "connect|read|write|recvfrom|sendto" | grep -v '"PK' | grep -v '".312.376'
