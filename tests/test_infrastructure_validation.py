"""Validation tests for the testing infrastructure setup."""

import pytest
import sys
from pathlib import Path


def test_pytest_runs():
    """Test that pytest is working correctly."""
    assert True


def test_python_version():
    """Verify Python version compatibility."""
    assert sys.version_info >= (3, 7)


def test_imports_work():
    """Test that we can import required libraries."""
    import py
    assert hasattr(py, 'path')


def test_temp_dir_fixture(temp_dir):
    """Validate the temp_dir fixture works."""
    assert temp_dir.exists()
    assert temp_dir.is_dir()
    
    # Create a test file
    test_file = temp_dir / "test.txt"
    test_file.write_text("test content")
    assert test_file.read_text() == "test content"


def test_mock_wheeldir_fixture(mock_wheeldir):
    """Validate the mock_wheeldir fixture."""
    assert mock_wheeldir.exists()
    assert mock_wheeldir.is_dir()
    
    wheel_files = list(mock_wheeldir.glob("*.whl"))
    assert len(wheel_files) == 3
    assert any("numpy" in f.name for f in wheel_files)


def test_sample_wheel_files_fixture(sample_wheel_files):
    """Validate sample wheel files fixture."""
    assert len(sample_wheel_files) == 5
    assert all(f.endswith(".whl") for f in sample_wheel_files)


def test_scripts_in_path():
    """Test that scripts directory is in sys.path."""
    scripts_path = str(Path.cwd() / "scripts")
    assert scripts_path in sys.path


@pytest.mark.unit
def test_unit_marker():
    """Test that unit marker works."""
    assert True


@pytest.mark.integration
def test_integration_marker():
    """Test that integration marker works."""
    assert True


@pytest.mark.slow
def test_slow_marker():
    """Test that slow marker works."""
    assert True


def test_capfd_wrapper_fixture(capfd_wrapper):
    """Test the capfd wrapper fixture."""
    print("test output")
    print("error output", file=sys.stderr)
    
    stdout, stderr = capfd_wrapper()
    assert "test output" in stdout
    assert "error output" in stderr


def test_mock_py_path_fixture(mock_py_path):
    """Test the py.path fixture."""
    import py
    assert isinstance(mock_py_path, py.path.local)
    assert mock_py_path.check(dir=True)