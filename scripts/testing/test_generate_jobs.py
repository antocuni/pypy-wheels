from generate_jobs import Jobs

def test_generate():
    pypys = {
        '6.0': ['2.7'],
        '7.0': ['2.7', '3.5'],
        }
    packages = [
        'numpy',
        'scipy'
        ]

    jobs = Jobs(pypys, packages, {})
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

    jobs = Jobs(pypys, packages, exclude)
    envs = list(jobs.generate())
    assert envs == [
        'PYPY="7.0.0" PY="2.7" PKG="numpy"',
        'PYPY="7.0.0" PY="3.5" PKG="numpy"',
        'PYPY="7.0.0" PY="3.5" PKG="scipy"',
        ]
