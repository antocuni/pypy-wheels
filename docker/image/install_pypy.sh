#!/bin/bash

set -e

# install pypy into /opt/pypy*
ALL_PYPYS=(
    # 6.0.0
    pypy-6.0.0-linux_x86_64-portable.tar.bz2
    pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2
    # 7.0.0
    pypy-7.0.0-linux_x86_64-portable.tar.bz2
    pypy3.5-7.0.0-linux_x86_64-portable.tar.bz2
    pypy3.6-7.0.0-alpha-20190209-linux_x86_64-portable.tar.bz2
    # 7.1.1
    pypy-7.1.1-linux_x86_64-portable.tar.bz2
    pypy3.6-7.1.1-beta-linux_x86_64-portable.tar.bz2
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

