#!/bin/bash

set -e

# install pypy into /opt/pypy*
ALL_PYPYS=(
    pypy-5.8-1-linux_x86_64-portable.tar.bz2
    pypy3.5-5.8-1-beta-linux_x86_64-portable.tar.bz2
    pypy-5.9-linux_x86_64-portable.tar.bz2
    pypy3.5-5.9-beta-linux_x86_64-portable.tar.bz2
    pypy-5.10.0-linux_x86_64-portable.tar.bz2
    pypy3.5-5.10.0-linux_x86_64-portable.tar.bz2
)

function install_pypy() {
    PYPY=$1
    URL=$2
    echo "Installing $PYPY"
    cd /tmp
    if [ ! -f $PYPY ]; then
        curl -O -L $URL
    fi
    # find the name of the top-level dir inside the tarball
    DIR=`tar -tf $PYPY | head -1 | cut -f1 -d"/"`

    cd /opt
    tar xf /tmp/$PYPY

    /opt/$DIR/bin/pypy -m ensurepip
    /opt/$DIR/bin/pypy -m pip install wheel
    echo "DONE"
    echo
}

for PYPY in "${ALL_PYPYS[@]}"
do
    URL=https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY
    install_pypy $PYPY $URL
done

# build wheels also for this nightly pypy
# PYPY="pypy-c-jit-94304-60c5692d6d40-linux64.tar.bz2"
# URL="http://buildbot.pypy.org/nightly/trunk/$PYPY"
#install_pypy $PYPY $URL

# build wheels for pypy 6 using the official tarball, while we wait for the portable build
PYPY="pypy2-v6.0.0-linux64.tar.bz2"
URL="https://bitbucket.org/pypy/pypy/downloads/$PYPY"
install_pypy $PYPY $URL
