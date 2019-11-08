#!/bin/bash

# this file is meant to be run inside the pypywheels docker image

#set -e -x
set -e

TARGET=$1
PYPY_VERSION=$2
PY_VERSION=$3
PKG=$4

TARGETDIR=/pypy-wheels/wheelhouse/$TARGET
PYPY_NAME="pypy$PY_VERSION-$PYPY_VERSION"

echo "PYPY_VERSION: ${PYPY_VERSION}"
echo "PY_VERSION: ${PY_VERSION}"
echo "PYPY_NAME: ${PYPY_NAME}"
echo

PYPY=/opt/pypy/$PYPY_NAME*/bin/pypy
if [ -f $PYPY ]
then
    echo "FOUND PYPY:" $PYPY
else
    echo "ERROR: PYPY does not exists: $PYPY"
    exit 1
fi

if [ "$PKG" = "numpy" ]
then
    # the recent versions of numpy requires a C99 compiler
    export CFLAGS="--std=c99"
fi

# Compile the wheels, for all pypys found inside /opt/
echo "Compiling wheel for $PKG"
echo "TARGETDIR: $TARGETDIR"
echo
cd

# pip install using our own wheel repo: this ensures that we don't
# recompile a package if the wheel is already available.
EXTRA="--extra-index https://antocuni.github.io/pypy-wheels/$TARGET"

# there are lots of packages which import numpy in the setup.py; this is
# wrong, but there is nothing we can do to fix them. Instead, let's simply
# install numpy always, before creating the wheel. We do a bit of extra
# useless work for other packages, but since we are using our wheels it's not
# too bad
$PYPY -m pip install $EXTRA numpy

# create the actual wheel
$PYPY -m pip wheel $EXTRA -w wheelhouse "$PKG"

# copy the wheels to the final directory
mkdir -p $TARGETDIR
cp wheelhouse/*.whl $TARGETDIR
echo "wheels copied:"
find $TARGETDIR -name '*.whl'

# Bundle external shared libraries into the wheels
PLAT=manylinux2010_x86_64
echo
echo "Running audiwheel..."
echo
for whl in wheelhouse/*.whl; do
    auditwheel repair --plat $PLAT "$whl" -w $TARGETDIR
done
