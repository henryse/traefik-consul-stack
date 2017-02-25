#!/usr/bin/env bash
# Set some pretty colors...
#
green='\033[1;32m'
dark_green='\033[0;32m'
white='\033[1;37m'
nocolor='\033[0m'

# Find the IP Address of the VM running docker.
#
export DOCKER_IP="0.0.0.0"

if hash docker-machine 2>/dev/null; then
    eval $(docker-machine env default)
    DOCKER_IP=$(docker-machine ip default)
else
    if [ "$(uname)" == "Darwin" ]; then
       DOCKER_IP=$(ifconfig en0 | awk '$1 == "inet" {print $2}')
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
       DOCKER_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
    fi
fi

# Fire it up!
#
docker-compose up -d

# Check it out
#
echo -e "${white}Docker host is ${green}${DOCKER_IP}${nocolor}"
echo -e ""
echo -e "Consul:           ${dark_green}${DOCKER_IP}${nocolor}:${green}8500${nocolor}"
echo -e "Traefik HTTP In:  ${dark_green}${DOCKER_IP}${nocolor}:${green}8080${nocolor}"
echo -e "Traefik Admin UI: ${dark_green}${DOCKER_IP}${nocolor}:${green}8081${nocolor}"