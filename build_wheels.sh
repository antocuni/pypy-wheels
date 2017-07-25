#!/bin/bash

# this file is meant to be run inside the antocuni/pypy-wheels docker image

set -e -x

packages=(
    netifaces
    psutil
    numpy
    scipy
    pandas
)

pypy -m ensurepip
pypy -m pip install wheel

# Compile wheels
echo "Compiling wheels..."
echo
cd
for PKG in "${packages[@]}"
do
    pypy -m pip install $PKG
    pypy -m pip wheel $PKG -w wheelhouse
done

# Bundle external shared libraries into the wheels
#
# XXX: auditwheel repair doesn't work because of this bug:
# https://github.com/NixOS/patchelf/issues/128
# try again when it's fixed
echo
echo "Running audiwheel..."
echo
mkdir -p /pypy-wheels/wheelhouse/
for whl in wheelhouse/*.whl; do
    #auditwheel repair --plat linux_x86_64  "$whl" -w /pypy-wheels/wheelhouse/
    cp "$whl" /pypy-wheels/wheelhouse/
done
