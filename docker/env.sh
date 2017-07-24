# this file is meant to be sourced to get the IMAGE and TAG env variables

cd "$(dirname "$0")"
IMAGE=antocuni/pypy-wheels
TAG=`cat $(git ls-files) | md5sum | head -c 8`
