#!/bin/bash

# install pypy into /opt/pypy*
ALL_PYPYS=(
    pypy-5.8-1-linux_x86_64-portable.tar.bz2
    pypy-5.9-linux_x86_64-portable.tar.bz2
    pypy3.5-5.8-1-beta-linux_x86_64-portable.tar.bz2
    pypy3.5-5.9-beta-linux_x86_64-portable.tar.bz2
)

function install_pypy() {
    PYPY=$1
    echo "Installing $PYPY"
    URL=https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY

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
    install_pypy $PYPY
done
