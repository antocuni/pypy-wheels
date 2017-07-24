#!/bin/bash

. docker/env.sh

echo "Trying to pull $IMAGE:$TAG"
if ! docker pull $IMAGE:$TAG
then
    echo "pull failed, building it"
    docker build docker -t $IMAGE:$TAG || exit
    docker push $IMAGE
fi
