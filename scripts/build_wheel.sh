#!/bin/bash

# this file is meant to be run inside the pypywheels docker image

#set -e -x
set -e

TARGET=$1
PYPY_VERSION=$2
PY_VERSION=$3
PKG=$4

TARGETDIR=/pypy-wheels/wheelhouse/$TARGET

if [[ "$PYPY_VERSION" = "2.7" ]]
then
    PYPY_NAME="pypy-$PYPY_VERSION"
else
    PYPY_NAME="pypy$PY-$PYPY_VERSION"
fi

PYPY=/opt/$PYPY_NAME*/bin/pypy
if [ -f $PYPY ]
then
    echo "FOUND PYPY: $PYPY"
else
    echo "ERROR: PYPY does not exists: $PYPY"
    exit 1
fi

# Compile the wheels, for all pypys found inside /opt/
echo "Compiling wheel for $PKG"
echo "TARGETDIR: $TARGETDIR"
echo
cd

# pip install using our own wheel repo: this ensures that we don't
# recompile a package if the wheel is already available.
EXTRA="--extra-index https://antocuni.github.io/pypy-wheels/$TARGET"
$PYPY -m pip wheel $EXTRA -w wheelhouse "$PKG"

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
