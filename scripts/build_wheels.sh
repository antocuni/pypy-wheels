#!/bin/bash

# this file is meant to be run inside the pypywheels docker image

set -e -x

TARGETDIR=/pypy-wheels/wheelhouse/$1

packages=(
    netifaces
    # psutil
    # numpy
    # scipy
    # pandas
)

# Compile wheels
echo "Compiling wheels..."
echo
cd
for PKG in "${packages[@]}"
do
    pypy -m pip install $PKG
    pypy -m pip wheel $PKG -w wheelhouse
done

# copy the wheels to the final directory
mkdir -p $TARGETDIR
cp wheelhouse/*.whl $TARGETDIR

# Bundle external shared libraries into the wheels
#
# XXX: auditwheel repair doesn't work because of this bug:
# https://github.com/NixOS/patchelf/issues/128
# try again when it's fixed
# echo
# echo "Running audiwheel..."
# echo
# for whl in wheelhouse/*.whl; do
#     auditwheel repair --plat linux_x86_64  "$whl" -w $TARGETDIR
# done
