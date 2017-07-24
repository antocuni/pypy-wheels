FROM centos:centos6
LABEL maintainer="anto.cuni@gmail.com"

# copied from pypa/manylinux
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV PATH /opt/rh/devtoolset-2/root/usr/bin:$PATH
ENV LD_LIBRARY_PATH /opt/rh/devtoolset-2/root/usr/lib64:/opt/rh/devtoolset-2/root/usr/lib:/usr/local/lib64:/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

COPY build_scripts /build_scripts
RUN bash build_scripts/build.sh && rm -r build_scripts

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

# pypy-wheels specific stuff
#
# uncomment this to avoid downloading pypy again and again
#COPY pypy-5.8-1-linux_x86_64-portable.tar.bz2 /tmp/
ADD install_pypy.sh /tmp
RUN /tmp/install_pypy.sh
ENV PATH="/opt/pypy/bin:${PATH}"

ADD install_packages.sh /tmp
RUN /tmp/install_packages.sh


