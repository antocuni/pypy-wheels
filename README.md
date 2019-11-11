# Binary wheels for PyPy

[![Build Status](https://travis-ci.org/antocuni/pypy-wheels.svg?branch=legacy-ubuntu)](https://travis-ci.org/antocuni/pypy-wheels)

The `legacy-ubuntu` branch of this repo continue to build ubuntu-based binary
wheels for PyPy 7.2.0 and 7.1.1. Eventually, this branch will fade away in
favor of master, where we build `manylinux2010`[1] wheels. You are encouraged to
switch to it.

Older version of PyPy are still partially supported, to avoid breaking your
builds: the exising wheels will not be deleted, but when a package release a
new version the wheel will **not** be updated.

These weels only work on Ubuntu: they are built on Ubuntu 14.04 but they
should work also on subsequent versions. To use them, you can invoke pip like
this:

```
$ pip install --extra-index-url https://antocuni.github.io/pypy-wheels/ubuntu numpy
```

Or, in case you use a `requirements.txt` file, you can put the extra index
option at the beginning:

```
--extra-index-url https://antocuni.github.io/pypy-wheels/ubuntu/
numpy
scipy
```

Please note that these are **not** manylinux[1] wheels: as such, they do not
contain all the required shared libraries, which need to be installed using
`apt-get`. In particular, `numpy` and `scipy` require `libatlas`, `libblas`
and `liblapack`.

[1] https://github.com/pypa/manylinux
