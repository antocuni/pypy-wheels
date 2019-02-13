import py
from generate_jobs import Jobs, TRAVIS_JOBS

def test_generate():
    pypys = {
        '6.0': ['2.7'],
        '7.0': ['2.7', '3.5'],
        }
    packages = [
        'numpy',
        'scipy'
        ]

    jobs = Jobs(pypys, packages, {}, [])
    envs = list(jobs.generate())
    assert envs == [
        'PYPY="6.0" PY="2.7" PKG="numpy"',
        'PYPY="7.0" PY="2.7" PKG="numpy"',
        'PYPY="7.0" PY="3.5" PKG="numpy"',
        'PYPY="6.0" PY="2.7" PKG="scipy"',
        'PYPY="7.0" PY="2.7" PKG="scipy"',
        'PYPY="7.0" PY="3.5" PKG="scipy"',
        ]


def test_exclude():
    pypys = {
        '6.0': ['2.7'],
        '7.0.0': ['2.7', '3.5'],
        }
    packages = [
        'numpy',
        'scipy',
        ]
    exclude = {
        'numpy': ('6.0', '*'),
        'scipy': ('*', '2.7')
        }

    jobs = Jobs(pypys, packages, exclude, [])
    envs = list(jobs.generate())
    assert envs == [
        'PYPY="7.0.0" PY="2.7" PKG="numpy"',
        'PYPY="7.0.0" PY="3.5" PKG="numpy"',
        'PYPY="7.0.0" PY="3.5" PKG="scipy"',
        ]


def test_include():
    pypys = {
        '7.0.0': ['2.7', '3.5'],
        }
    packages = [
        'numpy',
        ]
    include = [
        ('scipy', '6.0.0', '2.7'),
        ('pandas', '6.0.0', '2.7'),
        ]

    jobs = Jobs(pypys, packages, {}, include)
    envs = list(jobs.generate())
    assert envs == [
        'PYPY="7.0.0" PY="2.7" PKG="numpy"',
        'PYPY="7.0.0" PY="3.5" PKG="numpy"',
        'PYPY="6.0.0" PY="2.7" PKG="scipy"',
        'PYPY="6.0.0" PY="2.7" PKG="pandas"',
        ]

def test_travis_yml():
    root = py.path.local(__file__).dirpath('..', '..')
    yml = root.join('.travis.yml')
    travis_yml = yml.read()
    for env in TRAVIS_JOBS.generate():
        assert env in travis_yml, '.travis.yml and generate_jobs are out of sync'
