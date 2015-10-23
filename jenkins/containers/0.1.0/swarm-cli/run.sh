#!/bin/bash
set -x

WORKSPACE="/var/jenkins_home/workspace"
PARAMS="-fsroot ${WORKSPACE} -master http://jenkins-primary:8080"

if [ -n "${JENKINS_SWARM_OPTS}" ]; then
    PARAMS="${JENKINS_SWARM_OPTS} ${PARAMS}"
fi

mkdir -p "${WORKSPACE}"
java -jar /jenkins/swarm/swarm-client-"${SWARM_VERSION}"-jar-with-dependencies.jar ${PARAMS}
