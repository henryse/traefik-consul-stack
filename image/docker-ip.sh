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