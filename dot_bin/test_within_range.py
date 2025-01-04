import pytest
from list_within_range import is_in_range

def create_temp_file(directory, name):
    """Helper function to create a temporary file."""
    file_path = directory / name
    file_path.touch()
    return file_path


def test_is_in_range(tmp_path):
    # Create test files
    within_range = create_temp_file(tmp_path, "DSCF6528.JPG")
    outside_range = create_temp_file(tmp_path, "DSCF6540.JPG")
    exact_match = create_temp_file(tmp_path, "DSCF6528.JPG")
    invalid_format = create_temp_file(tmp_path, "INVALID.JPG")
    non_numeric = create_temp_file(tmp_path, "DSCFXXXX.JPG")
    edge_case_lower = create_temp_file(tmp_path, "DSCF6520.JPG")
    edge_case_upper = create_temp_file(tmp_path, "DSCF6530.JPG")

    # Perform tests
    assert is_in_range(within_range, 6520, 6530) == True
    assert is_in_range(outside_range, 6520, 6530) == False
    assert is_in_range(exact_match, 6528, 6528) == True
    assert is_in_range(invalid_format, 6520, 6530) == False
    assert is_in_range(non_numeric, 6520, 6530) == False
    assert is_in_range(edge_case_lower, 6520, 6530) == True
    assert is_in_range(edge_case_upper, 6520, 6530) == True

    # Test with no upper bound
    assert is_in_range(within_range, 6520, None) == True
    assert is_in_range(outside_range, 6520, None) == True
    assert is_in_range(exact_match, 6528, None) == True
    assert is_in_range(edge_case_lower, 6520, None) == True
    assert is_in_range(edge_case_upper, 6520, None) == True
    assert is_in_range(outside_range, 6541, None) == False
