This is the docker image used do build pypy wheels. It is based on the
pypy/manylinux image which is developed here:
https://github.com/pypy/manylinux

We rebuild the images only if necessary: for each image, we compute a tag
based on the md5sum of the build directory (see env.sh): if the tagged image
is already saved on dockerhub, we simply use it. Else, we rebuild and push to
dockerhub.

