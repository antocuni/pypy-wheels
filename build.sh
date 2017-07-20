#!/bin/bash
set -e -x

packages=(
    netifaces
)

PYPY=pypy-5.8-1-linux_x86_64-portable.tar.bz2

# install pypy
cd /tmp
curl -O -L https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY

cd /opt
tar xfv /tmp/$PYPY

cd /usr/bin
ln -s /opt/pypy*/bin/pypy .

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
