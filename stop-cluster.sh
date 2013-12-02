#!/bin/bash

source install/common.sh

check_usage $# 1 "Usage: $0 <VERSION>"

VERSION=$1
IMAGE=cassandra:$VERSION

test_image $VERSION

if sudo docker ps | grep $IMAGE >/dev/null; then
	cids=$(sudo docker ps | grep $IMAGE | awk '{ print $1 }')
	echo $cids | xargs echo "Killing and removing containers"
	sudo docker kill $cids > /dev/null
	sudo docker rm $cids   > /dev/null
fi
