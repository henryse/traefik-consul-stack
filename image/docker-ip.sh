#!/usr/bin/env bash
function local_ip_address {
    if [ "$(uname)" == "Darwin" ]; then
        ifconfig en0 | awk '$1 == "inet" {print $2}'
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
    else
        echo '0.0.0.0'
    fi
}

if hash docker-machine 2>/dev/null; then
    if [ "$(docker-machine status default)" == "Stopped" ]; then
        local_ip_address
    else
        docker-machine ip default
    fi
else
    local_ip_address
fi