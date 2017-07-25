There are two docker images:

- antocuni/pypy-wheels-base is built from the `base` directory: it's based on
  the http://github.com/pypa/manylinux: the main difference is that it uses
  CENTOS 6 instead of 5 (because PyPy doesn't work on centos 5 ATM)

- antocuni/pypy-wheels is based on pypy-wheels-base: on top of it, it installs
  pypy and the packages/libraries needed to build the wheels (e.g. atlas, blas
  and lacpack, needed to build numpy and scipy)

We decided to split the build into two images because pypy-wheels-base is
expected to change much less often than pypy-wheels, so rebuilding is faster.

We rebuild the images only if necessary: for each image, we compute a tag
based on the md5sum of the build directory (see env.sh): if the tagged image
is already saved on dockerhub, we simply use it. Else, we rebuild and push to
dockerhub.

