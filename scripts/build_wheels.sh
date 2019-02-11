#!/bin/bash

# this file is meant to be run inside the pypywheels docker image

#set -e -x
set -e

PYPY_VERSION="${PYPY/pypy*-/}"
TARGET=$1
TARGETDIR=/pypy-wheels/wheelhouse/$TARGET

packages=()

# newer versions of numpy don't work on older versions of pypy, pin it
if [[ "$PYPY_VERSION" >= "7.0" ]]
then
    packages+=(numpy)
else
    packages+=(numpy==1.15.4)
fi

packages=(
    #cryptography
    netifaces
    psutil
    scipy
    scipy==1.0.0
    pandas==0.20.3
    )

# the latest version of pandas work only on new pypys. This logic starts to be
# a bit too complex, we should probably write it in something better than bash
# :(
if [[ "$PYPY_VERSION" > "6.0" ]]
then
    packages+=(pandas)
fi

# Compile the wheels, for all pypys found inside /opt/
echo "Compiling wheels"
echo "TARGETDIR: $TARGETDIR"
echo
cd

# we expect PYPY to be something like "pypy-5.8", originated from the travis
# build matrix and passed via "docker run -e PYPY"
PYPY=/opt/$PYPY*/bin/pypy
if [ -f $PYPY ]
then
    echo "FOUND PYPY: $PYPY"
else
    echo "ERROR: PYPY does not exists: $PYPY"
    exit 1
fi

# pip install using our own wheel repo: this ensures that we don't
# recompile a package if the wheel is already available.
EXTRA="--extra-index https://antocuni.github.io/pypy-wheels/$TARGET"

for pkg in "${packages[@]}"
do
    echo "Compiling $pkg"
    $PYPY -m pip install $EXTRA "$pkg"
    $PYPY -m pip wheel $EXTRA -w wheelhouse "$pkg"
    echo
done

# copy the wheels to the final directory
mkdir -p $TARGETDIR
cp wheelhouse/*.whl $TARGETDIR
echo "wheels copied:"
find $TARGETDIR -name '*.whl'

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
