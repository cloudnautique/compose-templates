#!/bin/bash


apt-get update && apt-get install -y curl

export MON_IP=$(curl -s http://rancher-metadata/2015-07-25/self/container/primary_ip)
export MON_NAME=$(curl -s http://rancher-metadata/2015-07-25/self/container/name)

if [  "${1}" = "daemon" ]; then
    while [ ! "$(ls -A /etc/ceph)" ]; do
        sleep 1
    done
fi

exec /entrypoint.sh
