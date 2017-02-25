#!/usr/bin/env bash
export DOCKER_IP=$(/sbin/ip -4 -o addr show dev eth0| awk '{split($4,a,"/");print a[1]}')

docker-compose stop