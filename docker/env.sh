# this file is meant to be sourced to get the IMAGE and TAG env variables; the pwd MUST be the root of the repo

IMAGE=antocuni/pypy-wheels
TAG=`cat $(git ls-files docker) | md5sum | head -c 8`
