# this file is meant to be sourced to get the IMAGE and TAG env variables; the pwd MUST be the root of the repo

function _tag() {
    cat $(git ls-files $1) | md5sum | head -c 8
}

BASEIMAGE=antocuni/pypy-wheels-base
BASETAG=`_tag docker/base`

IMAGE=antocuni/pypy-wheels
TAG=`_tag docker/image`
