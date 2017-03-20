#!/usr/bin/env bash
set -e
#docker login -u tyediel -p $DOCKER_PASSWORD
docker build -t tyediel/devops:latest .
docker push tyediel/devops:latest
