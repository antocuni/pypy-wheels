#!/bin/bash

. docker/env.sh

# build wheels on ubuntu
echo "RUNNING DOCKER"
docker run -it --rm -v `pwd`:/pypy-wheels pypywheels/image:$TAG /pypy-wheels/scripts/build_wheel.sh manylinux2010 $PYPY $PY $PKG
STATUS=$?
echo "docker run exit status: $STATUS"
echo "end of run.sh"
exit $STATUS
