import pytest
import tempfile
import shutil
import os
from pathlib import Path
import py


@pytest.fixture
def temp_dir():
    """Create a temporary directory that gets cleaned up after the test."""
    temp_dir = tempfile.mkdtemp()
    yield Path(temp_dir)
    shutil.rmtree(temp_dir, ignore_errors=True)


@pytest.fixture
def mock_wheeldir(temp_dir):
    """Create a mock wheel directory with sample wheel files."""
    wheeldir = temp_dir / "wheeldir"
    wheeldir.mkdir()
    
    # Create sample wheel files
    (wheeldir / "numpy-1.13.1-pp258-pypy_41-linux_x86_64.whl").write_text("numpy wheel content")
    (wheeldir / "scipy-0.19.1-pp258-pypy_41-linux_x86_64.whl").write_text("scipy wheel content")
    (wheeldir / "matplotlib-2.0.2-pp258-pypy_41-linux_x86_64.whl").write_text("matplotlib wheel content")
    
    return wheeldir


@pytest.fixture
def mock_outdir(temp_dir):
    """Create a mock output directory for wheel index building."""
    outdir = temp_dir / "outdir"
    outdir.mkdir()
    return outdir


@pytest.fixture
def sample_wheel_files():
    """Return a list of sample wheel file names for testing."""
    return [
        "numpy-1.13.1-pp258-pypy_41-linux_x86_64.whl",
        "scipy-0.19.1-pp258-pypy_41-linux_x86_64.whl",
        "matplotlib-2.0.2-pp258-pypy_41-linux_x86_64.whl",
        "requests-2.18.4-py2.py3-none-any.whl",
        "six-1.10.0-py2.py3-none-any.whl"
    ]


@pytest.fixture
def mock_py_path(temp_dir):
    """Create a py.path.local object pointing to temp directory."""
    return py.path.local(str(temp_dir))


@pytest.fixture
def sample_html_content():
    """Return sample HTML content for testing index parsing."""
    return '''<html><body><h1>Test Index</h1>
<a href="numpy-1.13.1-pp258-pypy_41-linux_x86_64.whl">numpy-1.13.1-pp258-pypy_41-linux_x86_64.whl</a><br>
<a href="scipy-0.19.1-pp258-pypy_41-linux_x86_64.whl">scipy-0.19.1-pp258-pypy_41-linux_x86_64.whl</a><br>
</body></html>'''


@pytest.fixture
def mock_existing_packages(mock_outdir):
    """Create existing package directories in the output directory."""
    packages = ["numpy", "scipy", "requests"]
    for pkg in packages:
        pkg_dir = mock_outdir / pkg
        pkg_dir.mkdir()
        # Add some existing wheel files
        (pkg_dir / f"{pkg}-1.0.0-py3-none-any.whl").write_text(f"{pkg} old version")
    
    return packages


@pytest.fixture
def env_vars():
    """Set up environment variables for testing."""
    original_env = os.environ.copy()
    
    # Set test environment variables
    test_env = {
        "PYTHONPATH": str(Path.cwd() / "scripts"),
        "TEST_MODE": "true"
    }
    
    os.environ.update(test_env)
    
    yield test_env
    
    # Restore original environment
    os.environ.clear()
    os.environ.update(original_env)


@pytest.fixture
def capfd_wrapper(capfd):
    """Wrapper around capfd for easier output capturing."""
    def _capture():
        captured = capfd.readouterr()
        return captured.out, captured.err
    
    return _capture


@pytest.fixture(autouse=True)
def setup_sys_path():
    """Automatically add scripts directory to sys.path for all tests."""
    import sys
    scripts_path = str(Path.cwd() / "scripts")
    if scripts_path not in sys.path:
        sys.path.insert(0, scripts_path)
    
    yield
    
    # Clean up
    if scripts_path in sys.path:
        sys.path.remove(scripts_path)