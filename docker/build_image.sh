#!/bin/bash

. docker/env.sh

function _build_maybe() {
    local dir=$1
    local image=$2
    local tag=$3
    local extra_args="${@:4}"

    echo "Trying to pull $image:$tag"
    if ! docker pull $image:$tag
    then
        echo "pull failed, building it"
        docker build docker/$dir -t $image:$tag $extra_args || exit
        docker push $image
    fi
}

# build the base image
_build_maybe base $BASEIMAGE $BASETAG

# build the image, based on the proper base image
_build_maybe image $IMAGE $TAG --build-arg basetag=$BASETAG
