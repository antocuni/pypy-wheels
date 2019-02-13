# this is a helper to automatically generate the jobs for the .travis.yml file

PYPYS = {
    '6.0.0': ['2.7', '3.5'],
    '7.0.0': ['2.7', '3.5', '3.6'],
    }

PACKAGES = [
    'numpy',
    'scipy',
    'cython',
    'cryptography netifaces psutil',
    'scipy',
    'pandas',
    #scipy==1.0.0
    #pandas==0.20.3
]

# {package: (pypy, py)}
EXCLUDE = {
    'numpy': ('6.0.0', '*'),
    'scipy': ('6.0.0', '*'),
    'pandas': ('6.0.0', '*'),
    }

INCLUDE = [
    ('numpy==1.14.3',  '7.0.0', '2.7'),
    ('pandas==0.20.3', '7.0.0', '2.7'),
    ('scipy==1.1.0',   '7.0.0', '2.7'),
    ('cython==0.28.2', '7.0.0', '2.7'),
    ]

class Jobs(object):

    def __init__(self, pypys, packages, exclude, include):
        self.pypys = pypys
        self.packages = packages
        self.exclude = exclude
        self.include = include

    def is_excluded(self, pkg, pypy, py):
        rule = self.exclude.get(pkg)
        if not rule:
            return False
        ex_pypy, ex_py = rule
        return (ex_pypy in (pypy, '*') and
                ex_py in (py, '*'))

    def generate(self):
        all_pypys = sorted(self.pypys)
        for pkg in self.packages:
            for pypy in all_pypys:
                for py in self.pypys[pypy]:
                    if not self.is_excluded(pkg, pypy, py):
                        yield 'PYPY="%s" PY="%s" PKG="%s"' % (pypy, py, pkg)
        for pkg, pypy, py in self.include:
            yield 'PYPY="%s" PY="%s" PKG="%s"' % (pypy, py, pkg)


TRAVIS_JOBS = Jobs(PYPYS, PACKAGES, EXCLUDE, INCLUDE)
if __name__ == '__main__':
    all_envs = list(TRAVIS_JOBS.generate())
    # travis allows max 200 jobs, but we need to count also the docker-image
    # and the pytest jobs
    print 'env:'
    for env in all_envs:
        print '  - %s' % env

    if len(all_envs) >= 198:
        print
        print 'WARNING! Too many jobs: %d' % len(all_envs)
