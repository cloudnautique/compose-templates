FROM alpine:3.2

RUN apk add --update bash && rm -rf /var/cache/apk/*
ADD ./run.sh /opt/rancher/

VOLUME ["/opt/rancher", "/var/log/ceph"]
