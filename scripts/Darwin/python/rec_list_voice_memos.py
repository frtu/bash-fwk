#!/usr/bin/env python3
"""List Voice Memos as CSV: title;path, sorted newest to oldest."""

import json
import subprocess
from pathlib import Path

RECORDINGS_DIR = Path.home() / "Library/Group Containers/group.com.apple.VoiceMemos.shared/Recordings"

def get_title(filepath: Path) -> str:
    """Extract title from m4a metadata using ffprobe, fallback to filename."""
    try:
        result = subprocess.run(
            [
                "ffprobe", "-v", "quiet", "-print_format", "json",
                "-show_entries", "format_tags=title", str(filepath)
            ],
            capture_output=True,
            text=True,
        )
        data = json.loads(result.stdout)
        title = data.get("format", {}).get("tags", {}).get("title")
        if title:
            return title
    except Exception:
        pass
    return filepath.stem


def main():
    if not RECORDINGS_DIR.exists():
        print(f"Directory not found: {RECORDINGS_DIR}", file=__import__("sys").stderr)
        return

    m4a_files = list(RECORDINGS_DIR.glob("*.m4a"))

    # Sort by modification time, oldest first
    m4a_files.sort(key=lambda f: f.stat().st_mtime)

    for filepath in m4a_files:
        title = get_title(filepath)
        escaped_path = str(filepath).replace(" ", "\\ ")
        print(f"{title};{escaped_path}")


if __name__ == "__main__":
    print("Listing Voice Memos as CSV: title;path, sorted newest to oldest at ", RECORDINGS_DIR)
    main()
