# install pypy into /opt/pypy

PYPY=pypy-5.8-1-linux_x86_64-portable.tar.bz2
URL=https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY

cd /tmp
if [ ! -f $PYPY ]; then
    curl -O -L $URL
fi
DIR=`tar -tf $PYPY | head -1 | cut -f1 -d"/"`

cd /opt
tar xf /tmp/$PYPY
ln -s $DIR pypy

/opt/pypy/bin/pypy -m ensurepip
/opt/pypy/bin/pypy -m pip install wheel
