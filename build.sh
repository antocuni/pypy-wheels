#!/bin/bash
set -e -x

packages=(
    netifaces
)

# install pypy
PYPY=pypy2-v5.8.0-linux64
cd /tmp && curl -O -L https://bitbucket.org/pypy/pypy/downloads/$PYPY.tar.bz2
cd /opt && tar xfv /tmp/$PYPY.tar.bz2
export PATH=/opt/$PYPY/bin:$PATH

pypy -m ensurepip
pypy -m pip install wheel py

# Compile wheels
for PKG in $packages
do
    pypy -m pip wheel $PKG -w wheelhouse
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /pypy-wheels/wheelhouse/
done
