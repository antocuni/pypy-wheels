#!/bin/bash

# gcc
yum install -y gcc blas-devel lapack-devel

# auditwheels
yum install -y epel-release
yum install -y python34
python3 -m ensurepip
python3 -m pip install auditwheel
