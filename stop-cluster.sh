#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <VERSION>"
	exit 1
fi
VERSION=$1
IMAGE=cassandra:$VERSION

if sudo docker ps | grep $IMAGE >/dev/null; then
	cids=$(sudo docker ps | grep $IMAGE | awk '{ print $1 }')
	echo $cids | xargs echo "Killing and removing containers"
	sudo docker kill $cids > /dev/null
	sudo docker rm $cids   > /dev/null
fi
