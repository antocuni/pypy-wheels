#!/bin/bash
set -e -x

packages=(
    netifaces
    # psutil
    # numpy
    # scipy
    # pandas
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
echo
echo "Running audiwheel..."
echo
mkdir -p /pypy-wheels/wheelhouse/
for whl in wheelhouse/*.whl; do
    #auditwheel repair "$whl" -w /pypy-wheels/wheelhouse/
    cp "$whl" /pypy-wheels/wheelhouse/
done

# # build the index
# cd ~/build/antocuni/pypy-wheels/
# python build_index.py ~/wheelhouse /tmp/gh-pages

