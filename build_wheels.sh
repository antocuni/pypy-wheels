#!/bin/bash
set -e -x

packages=(
    netifaces
    # psutil
    # numpy
    # scipy
    # pandas
)

# Compile wheels
cd
for PKG in "${packages[@]}"
do
    pypy -m pip install $PKG
    pypy -m pip wheel $PKG -w wheelhouse
done

# # Bundle external shared libraries into the wheels
# for whl in wheelhouse/*.whl; do
#     auditwheel repair "$whl" -w /pypy-wheels/wheelhouse/
# done

# # build the index
# cd ~/build/antocuni/pypy-wheels/
# python build_index.py ~/wheelhouse /tmp/gh-pages

