#!/bin/bash

. docker/env.sh

# build wheels on centos6
#docker run -it --rm -v `pwd`:/pypy-wheels pypywheels/centos6:$TAG /pypy-wheels/scripts/build_wheels.sh

# build wheels on ubuntu
echo "RUNNING DOCKER"
docker run -e "PYPY" -it --rm -v `pwd`:/pypy-wheels pypywheels/ubuntu14.04:$TAG /pypy-wheels/scripts/build_wheels.sh ubuntu
STATUS=$?
echo "docker run exit status: $STATUS"
echo "end of run.sh"
exit $STATUS
