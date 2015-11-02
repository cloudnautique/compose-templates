FROM alpine:3.2

RUN apk add --update bash && rm -rf /var/cache/apk/*
ADD . /opt/rancher/

VOLUME "/opt/rancher"
