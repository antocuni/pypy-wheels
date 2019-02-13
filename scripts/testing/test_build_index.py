import py
import re
from build_index import IndexBuilder

def w(d, path, content):
    f = d.join(path)
    f.ensure()
    f.write(content)
    return f

def find_links(f):
    html = f.read()
    matches = re.findall('<a href="(.*)">(.*)</a>', html)
    return matches

class TestIndexBuilder:

    def test_parse(self):
        fname = py.path.local('numpy-1.13.1-pp258-pypy_41-linux_x86_64.whl')
        name, version = IndexBuilder.parse(fname)
        assert name == 'numpy'
        assert version == '1.13.1'

    def test_copy_wheels(self, tmpdir):
        src = tmpdir.join('src')
        dst = tmpdir.join('dst')
        #
        w(src, 'netifaces-10.1-bla.whl', 'AAA')
        w(src, 'numpy-1.2-bla.whl', 'BBB')
        w(dst, 'numpy/numpy-1.1-bla.whl', 'existing 1.1')
        w(dst, 'numpy/numpy-1.2-bla.whl', 'existing 1.2')
        #
        builder = IndexBuilder(src, dst)
        builder.copy_wheels()
        assert dst.join('netifaces/netifaces-10.1-bla.whl').read() == 'AAA'
        assert dst.join('numpy/numpy-1.1-bla.whl').read() == 'existing 1.1'
        # note: this has NOT been copied, because it already existed
        assert dst.join('numpy/numpy-1.2-bla.whl').read() == 'existing 1.2'

    def test_build_index(self, tmpdir):
        src = tmpdir.join('src')
        dst = tmpdir.join('dst')
        w(src, 'netifaces-10.1-bla.whl', 'AAA')
        w(src, 'numpy-1.1-bla.whl', 'BBB')
        w(src, 'numpy-1.2-bla.whl', 'CCC')
        #
        # this is a dir which already exists in gh-pages but for which we
        # didn't build any new wheel. We want to ensure that it's still linked
        # in the index
        dst.join('scipy').ensure(dir=True)
        #
        builder = IndexBuilder(src, dst)
        builder.copy_wheels()
        builder.build_index()
        #
        # check the main index
        links = find_links(dst.join('index.html'))
        assert sorted(links) == [
            ('netifaces', 'netifaces'),
            ('numpy', 'numpy'),
            ('scipy', 'scipy'),
        ]
        # check the index for numpy
        links = find_links(dst.join('numpy/index.html'))
        assert sorted(links) == [
            ('numpy-1.1-bla.whl', 'numpy-1.1-bla.whl'),
            ('numpy-1.2-bla.whl', 'numpy-1.2-bla.whl')
        ]
