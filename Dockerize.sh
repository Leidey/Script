#!/usr/bin/env bash
set -e
#docker login -u tyediel -p $DOCKER_PASSWORD $BUILD_NUMBER
docker build -t tyediel/devops:$BUILD_NUMBER .
docker push tyediel/devops:$BUILD_NUMBER
