#!/bin/bash

# packages needed to build numpy and scipy
yum install -y gcc gcc-c++ atlas-devel blas-devel lapack-devel

# auditwheels
yum install -y epel-release
yum install -y python34
python3 -m ensurepip
python3 -m pip install auditwheel
