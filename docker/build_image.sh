#!/bin/bash

set -e

. docker/env.sh

function tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

function _build_maybe() {
    local dir=$1
    local image=$2
    local tag=$3
    local extra_args="${@:4}"

    echo "Checking $image:$tag"
    if tag_exists $image $tag
    then
        echo "  image already on docker hub, nothing to do"
    else
        echo "  image does not exist, building it"
        docker build docker/$dir -t $image:$tag $extra_args || exit
        if [ "$TRAVIS_PULL_REQUEST" = "false" ]
        then
            echo "skipping docker push because this is a PR"
        else
            docker push $image
        fi
    fi
}

# centos6-based build:
#_build_maybe base pypywheels/centos6-base $BASETAG
#_build_maybe image pypywheels/centos6 $TAG --build-arg baseimage=pypywheels/centos6-base:$BASETAG

# ubuntu-based build
_build_maybe image pypywheels/ubuntu14.04 $TAG --build-arg baseimage=ubuntu:14.04
