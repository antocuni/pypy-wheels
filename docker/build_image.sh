#!/bin/bash

cd "$(dirname "$0")"
. env.sh

echo "Trying to pull $IMAGE:$TAG"
if ! docker pull $IMAGE:$TAG
then
    echo "pull failed, building it"
    docker build . -t $IMAGE:$TAG || exit
    docker push $IMAGE
fi
