from __future__ import print_function

# this is a helper to automatically generate the jobs for the .travis.yml file

PYPYS = {
    '7.2.0': ['2.7', '3.6'],
    '7.3.7': ['2.7', '3.6', '3.7', '3.8'],
    }


# xgboost is commented out because the resulting wheel is >100MB, which is the
# maximum file size limit for hosting files on github pages. Probably we
# should switch to another way to host the wheels :(
PACKAGES = [
    'numpy',
    'scipy',
    'cython',
    'cryptography',
    'netifaces',
    'gevent',
    'psutil',
    'pandas',
#    'xgboost',
]

# {package: (pypy, py)}
EXCLUDE = {
    'scipy': ('7.2.0', '3.6'),
    'psutil': ('7.2.0', '2.7'),
    'gevent': ('*', '3.6'),
    }

INCLUDE = [
    ## ('numpy==1.14.3',  '7.3.1', '2.7'),
    ('pandas==0.24.2', '7.3.1', '3.6'),
    ('scipy==1.2.1', '7.3.1', '3.6'),
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
    print('env:')
    for env in all_envs:
        print('  - %s' % env)

    if len(all_envs) >= 198:
        print()
        print('WARNING! Too many jobs: %d' % len(all_envs))
