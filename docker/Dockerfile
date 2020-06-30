FROM pypywheels/manylinux2010-pypy_x86_64
LABEL maintainer="anto.cuni@gmail.com"

ENV REFRESHED_AT 2020-04-07

# this is needed for numpy and scipy XXX: investigate whether we need to use
# this to get a newer version of the library?
# https://fedoraproject.org/wiki/EPEL
RUN yum install -y openblas-devel

# needed to build cryptography
RUN yum install -y openssl-devel
