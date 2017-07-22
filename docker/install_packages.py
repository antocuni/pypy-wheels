#!/bin/bash

# gcc
yum -y gcc

# auditwheels
yum install -y epel-release
yum install -y python34
python3 -m ensurepip
python3 -m pip install auditwheel
