from build_index import IndexBuilder

def w(d, path, content):
    f = d.join(path)
    f.ensure()
    f.write(content)
    return f

class TestIndexBuilder:

    def test_copy_wheels(self, tmpdir):
        src = tmpdir.join('src')
        dst = tmpdir.join('dst')
        #
        w(src, 'netifaces/netifaces-10.1-bla.whl', 'AAA')
        w(src, 'numpy/numpy-1.2-bla.whl', 'BBB')
        w(dst, 'numpy/numpy-1.1-bla.whl', 'existing 1.1')
        w(dst, 'numpy/numpy-1.2-bla.whl', 'existing 1.2')
        #
        builder = IndexBuilder(src, dst)
        builder.copy_wheels()
        assert dst.join('netifaces/netifaces-10.1-bla.whl').read() == 'AAA'
        assert dst.join('numpy/numpy-1.1-bla.whl').read() == 'existing 1.1'
        # note: this has NOT been copied, because it already existed
        assert dst.join('numpy/numpy-1.2-bla.whl').read() == 'existing 1.2'
