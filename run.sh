#!/bin/bash

. docker/env.sh
docker run -it --rm -v `pwd`:/pypy-wheels $IMAGE:$TAG /pypy-wheels/build_wheels.sh
