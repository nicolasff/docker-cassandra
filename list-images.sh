#!/bin/bash

sudo docker images | grep -w '^cassandra' | awk '{print $2}' | sort | uniq
