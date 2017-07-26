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

## TODO / help wanted

In case you are interested in helping, pull requests are welcome. Here is a
random list of features which would be nice to have:

1. It is possible that if you fork the repo e create a PR, the travis build
   will fail because it does not have the rights to do `docker push` after
   rebuilding the image, and/or `git push gh-pages` after rebuilding the
   index. We should insert a check and avoid that.
   
2. If you want to build a new package, just add it `build_wheels.sh` and make
   sure it compiles correctly. You might need to `apt-get install` more
   packages in `docker/image/install_packages.sh`.
   
3. If you want to build wheels for `OS/X` or other linux distros, feel free to
   do so :)
   
4. Currently, the build script recompiles every package each time it is
   run. It would be nice to skip the build in case a wheel for a specific
   version of a package is already there.
