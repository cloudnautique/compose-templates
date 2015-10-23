FROM alpine:3.2

ENV SWARM_VERSION 2.0
RUN apk add --update curl && rm -rf /var/cache/apk/* && rm -rf /var/cache/apk/* && \
    mkdir -p /jenkins/swarm/ && \
    curl -Lo /jenkins/swarm/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar \
    http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar

ADD ./run.sh /jenkins/swarm/run.sh

VOLUME /jenkins/swarm
