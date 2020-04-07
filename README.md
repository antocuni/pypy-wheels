# Binary wheels for PyPy

[![Build Status](https://travis-ci.org/antocuni/pypy-wheels.svg?branch=master)](https://travis-ci.org/antocuni/pypy-wheels)

This repo contains PyPy binary wheels for some popular packages. This is still
highly experimental. There is a travis cron job which runs daily, to ensure
that we build new wheels if there are new releases of such packages.

We continuously build wheels for the two latest PyPy releases, which
currently are:

  - PyPy 7.3.0

  - PyPy 7.2.0

Older version of PyPy are still partially supported, to avoid breaking your
builds: the exising wheels will not be deleted, but when a package release a
new version the wheel will **not** be updated.

We build manylinux2010[1] wheels, which means that they should work on any
reasonably recent linux distribution. Note that the ``pip`` which is shipped
by ``pypy <=7.2.0`` is very old and thus does not support ``manyinux2010``
wheels. Make sure to upgrade your ``pip`` as a first step.


To use the wheels, you can invoke pip like this:

```
$ pip install -U pip
$ pip install --extra-index-url https://antocuni.github.io/pypy-wheels/manylinux2010 numpy
```

Or, in case you use a `requirements.txt` file, you can put the extra index
option at the beginning:

```
--extra-index-url https://antocuni.github.io/pypy-wheels/manylinux2010/
numpy
scipy
```

[1] https://github.com/pypa/manylinux

At the moment of writing, we provide binary wheels for the following packages:

- numpy
- scipy
- cython
- pandas
- xgboost
- cryptography
- psutil
- netifaces
- gevent

If you want more packages, pull requests are welcome.

## Status of the packages

Plase note that the purpose of this repo is only to provide wheels for the
existing packages in order to save build time. The actual functionalities of
the packages might or might not work correctly on PyPy. If you encounter a
bug, do **not** open an issue on this repo as this is not the right place:
please report it to the PyPy and/or the specific package issue trackers.

## Older Ubuntu-based images

Before switching to manylinux2010, this repo used to built ubuntu-based
wheels. These are still available at the old address, to avoid breaking your
build unexpectedly. New versions of the wheels will be built for a while in
the `legacy-ubuntu`[2] branch.  Note that scipy wheels are no longer supported
on that branch, so if you need a binary scipy wheel for pypy, you should use
the manylinux ones.

To install the old wheels, use:

```
$ pip install --extra-index-url https://antocuni.github.io/pypy-wheels/ubuntu numpy
```

[2] https://github.com/antocuni/pypy-wheels/tree/legacy-ubuntu
