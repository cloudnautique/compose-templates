#!/bin/bash

if [ "$(grep '^deb.*trusty-backports.*$' /etc/apt/sources.list|wc -l)" -eq "0" ]; then
    echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse">> /etc/apt/sources.list
    apt-get update && apt-get install -y curl jq/trusty-backports
fi

METADATA_URL="http://rancher-metadata/2015-07-25"
ALL_METADATA="$(curl -s -H 'Accept: application/json' ${METADATA_URL})"

MON_NAME=$(echo ${ALL_METADATA} | jq -r '.services[]| select(.name=="ceph-monitors") | .containers[0]')
if [ "$(echo ${ALL_METADATA} | jq -r '.services[]| select(.name=="ceph-monitors") | .containers | length')" -gt 1 ]; then
    MON_NAME=$(echo ${ALL_METADATA} | jq -r '.services[]| select(.name=="ceph-monitors") | .containers | join(",")')
fi

echo "MON_NAME: $MON_NAME"

MON_IP=
for container in $(echo ${ALL_METADATA} | jq -r '.services[] | select(.name=="ceph-monitors") | .containers[]'); do
    IP=$(curl -s ${METADATA_URL}/containers/${container}/primary_ip)
    if [ -n "${MON_IP}" ]; then
        MON_IP="${MON_IP},${IP}"
    else
        MON_IP="${IP}"
    fi
done

export MDS_NAME=$(echo ${ALL_METADATA} | jq -r '.services[] | select(.name=="ceph-mds") | .containers[0]')
echo "MDS_NAME: ${MDS_NAME}"
export RGW_NAME=$(echo ${ALL_METADATA} | jq -r '.services[] | select(.name=="ceph-rgw") | .containers[0]')
echo "RGW_NAME: ${RGW_NAME}"

export MON_IP
export MON_NAME
export MDS_NAME

echo "MON_IP: ${MON_IP}"

if [ -z "${ETCDCTL_PEERS}" ]; then
    export HOSTNAME=$(echo ${ALL_METADATA} | jq -r '.self.container.primary_ip')
    while [ ! "$(ls -A /etc/ceph)" ]; do
        sleep 1
    done
fi
exec "$@"
