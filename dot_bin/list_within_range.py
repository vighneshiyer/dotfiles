import argparse
from pathlib import Path
from typing import Iterator, Optional
import sys


def is_in_range(file: Path, start_number: int, end_number: Optional[int]) -> bool:
    """Check if a file name matches the range criteria."""
    name = file.stem  # Get the file name without extension
    if name.startswith("DSCF"):
        try:
            number = int(name[4:])  # Extract the number part
            if end_number is None:
                return start_number <= number
            return start_number <= number <= end_number
        except ValueError:
            return False
    return False


def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Filter JPG files by numeric range.")
    parser.add_argument("--files-only", action="store_true", default=False, help="Only list the file names, not including the directory prefix")
    parser.add_argument(
        "directory", type=Path, help="The directory containing JPG files."
    )
    parser.add_argument(
        "start_number", type=int, help="The starting number in the range."
    )
    parser.add_argument(
        "end_number",
        type=int,
        nargs="?",
        help="The ending number in the range (optional, defaults to unbounded).",
    )
    args = parser.parse_args()

    directory = args.directory
    start_number = args.start_number
    end_number = args.end_number

    if end_number is not None and start_number > end_number:
        print("Error: <start_number> must be less than or equal to <end_number>.")
        sys.exit(1)

    # Glob for JPG files recursively in the directory
    if not directory.is_dir():
        print(f"Error: {directory} is not a valid directory.")
        sys.exit(1)

    jpg_files: Iterator[Path] = filter(
        lambda file: is_in_range(file, start_number, end_number),
        directory.rglob("*.JPG"),
    )

    if args.files_only:
        file_names = [f.name for f in jpg_files]
        for file in sorted(file_names):
            print(file)
    else:
        # Print the filtered file paths relative to the script's working directory
        for file in sorted(jpg_files):
            print(file)


if __name__ == "__main__":
    main()
