ARG baseimage
FROM $baseimage
LABEL maintainer="anto.cuni@gmail.com"

ADD install_packages.sh /tmp
RUN /tmp/install_packages.sh

# uncomment these to avoid downloading pypy again and again
#COPY pypy-5.8-1-linux_x86_64-portable.tar.bz2 /tmp/
#COPY pypy-5.9-linux_x86_64-portable.tar.bz2 /tmp/

ADD install_pypy.sh /tmp
RUN /tmp/install_pypy.sh
ENV PATH="/opt/pypy/bin:${PATH}"

