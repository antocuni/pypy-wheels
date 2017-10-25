#!/bin/bash

# this file is meant to be run inside the pypywheels docker image

set -e -x

TARGET=$1
TARGETDIR=/pypy-wheels/wheelhouse/$TARGETDIR

packages=(
    netifaces
    psutil
    # numpy
    # scipy
    # pandas
)

# Compile wheels
echo "Compiling wheels..."
echo
cd

    # pip install using our own wheel repo: this ensures that we don't
    # recompile a package if the wheel is already available.
    pypy -m pip install "${packages[@]}" \
         --extra-index https://antocuni.github.io/pypy-wheels/$TARGET

    pypy -m pip wheel "${packages[@]}" \
         -w wheelhouse \
         --extra-index https://antocuni.github.io/pypy-wheels/$TARGET


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
