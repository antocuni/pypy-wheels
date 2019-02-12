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

class Jobs(object):

    def __init__(self, pypys, packages):
        self.pypys = pypys
        self.packages = packages

    def generate(self):
        all_pypys = sorted(self.pypys)
        for pkg in self.packages:
            for pypy in all_pypys:
                for py in self.pypys[pypy]:
                    yield 'PYPY="%s" PY="%s" PKG="%s"' % (pypy, py, pkg)

def main():
    pypy_w = width(PYPYS)
    packages_w = width(PACKAGES)


if __name__ == '__main__':
    jobs = Jobs(PYPYS, PACKAGES)
    all_envs = list(jobs.generate())
    # travis allows max 200 jobs, but we need to count also the docker-image
    # and the pytest jobs
    for env in all_envs:
        print '- env: %s' % env

    if len(all_envs) >= 198:
        print
        print 'WARNING! Too many jobs: %d' % len(all_envs)
