from __future__ import print_function
import sys
import py

class IndexBuilder(object):

    def __init__(self, wheeldir, outdir):
        self.wheeldir = py.path.local(wheeldir)
        self.outdir = py.path.local(outdir)
        self.updated_packages = set()

    @classmethod
    def parse(cls, f):
        name, version, _ = f.basename.split('-', 2)
        return name, version

    def copy_wheels(self):
        for whl in self.wheeldir.visit('*.whl'):
            print('Collecting wheel:', whl.basename)
            name, version = self.parse(whl)
            self.updated_packages.add(name)
            d = self.outdir.join(name).ensure(dir=True)
            dst = d.join(whl.basename)
            if dst.check(file=False):
                whl.copy(d)
            else:
                print('    already exists, skipping')

    def all_packages(self):
        for f in self.outdir.listdir():
            if f.check(dir=True):
                yield f.basename

    def build_index(self):
        print('Building index files...')
        self._write_index(self.outdir, 'PyPy Wheel Index', self.all_packages())
        for pkg in self.updated_packages:
            d = self.outdir.join(pkg)
            wheels = [whl.basename for whl in d.listdir('*.whl')]
            self._write_index(d, 'Links for %s' % pkg, wheels)
        print('OK')

    def _write_index(self, d, title, links):
        lines = [
            '<html><body><h1>{title}</h1>'.format(title=title)
            ]
        for name in links:
            line = '<a href="{name}">{name}</a><br>'.format(name=name)
            lines.append(line)
        lines.append('</body></html>')
        html = '\n'.join(lines)
        d.join('index.html').write(html)


def main():
    wheeldir = sys.argv[1]
    outdir = sys.argv[2]
    index = IndexBuilder(wheeldir, outdir)
    index.copy_wheels()
    index.build_index()


if __name__ == '__main__':
    main()
