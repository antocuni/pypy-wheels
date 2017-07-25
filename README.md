# Binary wheels for PyPy

This repo contains PyPy binary wheels for some popular packages. This is still highly experimental.

Currently, we provide only wheels for Ubuntu: they are built on Ubuntu 14.04 but they should work also on subsequent versions. To use them, you can invoke pip like this:

```
$ pip install --extra-index https://antocuni.github.io/pypy-wheels/ubuntu numpy
```

Or, in case you use a `requirements.txt` file, you can put the extra index option at the beginning:

```
--extra-index https://antocuni.github.io/pypy-wheels/ubuntu/
numpy
scipy
```

Please note that these are **not** manylinux[1] wheels: as such, they do not contain all the required shared libraries, which need to be installed using `apt-get`. In particular, `numpy` and `scipy` require `libatlas`, `libblas` and `liblapack`.

[1] https://github.com/pypa/manylinux

Currently, we provide binary wheels for the following packages:

- numpy
- scipy
- pandas
- psutil
- netifaces

If you want more packages, pull requests are welcome.

## Status of the packages

Plase note that the purpose of this repo is only to provide wheels for the existing packages in order to save build time. The actual functionalities of the packages might or might not work correctly on PyPy. If you encounter a bug, do **not** open an issue on this repo as this is not the right place: please report it to the PyPy and/or the specific package issue trackers.

## Why not manylinux1 wheels?

Currently, it is not possible to build PyPy on centos5, which is required for manylinux1. Moreover, there are other issues to be fixed fist, such as this one: https://bitbucket.org/pypy/pypy/issues/2617/
