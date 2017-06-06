#!/usr/bin/env bash
#**********************************************************************
#    Copyright (c) 2017 Henry Seurer
#
#    Permission is hereby granted, free of charge, to any person
#    obtaining a copy of this software and associated documentation
#    files (the "Software"), to deal in the Software without
#    restriction, including without limitation the rights to use,
#    copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the
#    Software is furnished to do so, subject to the following
#    conditions:
#
#    The above copyright notice and this permission notice shall be
#    included in all copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#    OTHER DEALINGS IN THE SOFTWARE.
#
#**********************************************************************

# Set some pretty colors...
#
green='\033[1;32m'
dark_green='\033[0;32m'
white='\033[1;37m'
nocolor='\033[0m'

# Find the IP Address of the VM running docker.
#

if hash docker-machine env default 2>/dev/null; then
    eval $(docker-machine env default)
    export DOCKER_IP=$(docker-machine ip default)
else
    if [ "$(uname)" == "Darwin" ]; then
       export DOCKER_IP=$(ifconfig en0 | awk '$1 == "inet" {print $2}')
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
       export DOCKER_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
    else
       export DOCKER_IP="127.0.0.1"
    fi
fi

if [ "${DOCKER_IP}" == "" ]; then
    export DOCKER_IP="127.0.0.1"
fi

# Setup traefik.toml file with the correct IP Address
#
export CONSUL_IP=${DOCKER_IP}
cat $(pwd)/traefik/traefik.toml.sed |  sed -e "s/CONSUL_IP/${CONSUL_IP}/g" > $(pwd)/../env/$1/traefik.toml

# We need to get the password:
#
export PASSWORD_JSON=$(cat password.json);

# Fire it up!
#
pushd ../env/$1
docker-compose up -d --remove-orphans
popd

# Dump Handy IP Addresses
#

echo -e "${white}Docker host is ${green}${DOCKER_IP}${nocolor} as ${1}"
echo -e ""
echo -e "Consul:           ${dark_green}${DOCKER_IP}${nocolor}:${green}8500${nocolor}"
echo -e "Traefik HTTP In:  ${dark_green}${DOCKER_IP}${nocolor}:${green}8080${nocolor}"
echo -e "Traefik Admin UI: ${dark_green}${DOCKER_IP}${nocolor}:${green}8081${nocolor}"
echo -e "Portainer:        ${dark_green}${DOCKER_IP}${nocolor}:${green}9000${nocolor}"