#!/bin/bash

if [ -f /etc/debian_version ]
then
    # we are on ubuntu
    export DEBIAN_FRONTEND noninteractive
    apt-get update
    apt-get install -y curl gcc g++

    # needed for numpy and scipy
    apt-get install -y gfortran libatlas-dev libblas-dev liblapack-dev
else
    # we are on centos
    # packages needed to build numpy and scipy
    yum install -y atlas-devel blas-devel lapack-devel
fi
