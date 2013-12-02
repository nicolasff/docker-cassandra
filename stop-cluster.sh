#!/bin/bash

IMAGE=cassandra:2.0.3

if sudo docker ps | grep $IMAGE >/dev/null; then
	cids=$(sudo docker ps | grep $IMAGE | awk '{ print $1 }')
	echo $cids | xargs echo "Killing and removing containers"
	sudo docker kill $cids > /dev/null
	sudo docker rm $cids   > /dev/null
fi
