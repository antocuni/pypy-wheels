#!/bin/bash

set -e

. docker/env.sh

function tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

function _build_maybe() {
    local image=$1
    local tag=$2

    echo "Checking $image:$tag"
    if tag_exists $image $tag
    then
        echo "  image already on docker hub, nothing to do"
    else
        echo "  image does not exist, building it"
        docker build docker -t $image:$tag || exit
        if [ "$TRAVIS_PULL_REQUEST" = "false" ]
        then
            docker push $image
        else
            echo "skipping docker push because this is a PR"
        fi
    fi
}

_build_maybe pypywheels/image $TAG
