#!/bin/bash
set -e -x

packages=(
    netifaces
)

# install pypy
cd /tmp
wget https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.8.0-linux64.tar.bz2

cd /opt
tar xfv /tmp/pypy2-v5.8.0-linux64.tar.bz2

cd /usr/bin
ln -s /opt/pypy2-v5.8.0-linux64/bin/pypy .

pypy -m ensurepip
pypy -m pip install wheel

# Compile wheels
for PKG in $packages
do
    pypy -m pip wheel $PKG -w wheelhouse
done

# # Bundle external shared libraries into the wheels
# for whl in wheelhouse/*.whl; do
#     auditwheel repair "$whl" -w /pypy-wheels/wheelhouse/
# done
