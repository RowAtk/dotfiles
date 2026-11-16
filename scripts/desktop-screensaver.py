#!/usr/bin/env python3
"""Launch the arcade attract mode in a supervised native Wayland Kitty window."""
import argparse
from pathlib import Path
import subprocess

FLAG = Path.home() / ".local/state/charcoal-copper/boring"
ROOT = Path(__file__).resolve().parent.parent
PYTHON = Path.home() / ".local/share/charcoal-arcade/venv/bin/python"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--preview", action="store_true")
    args = parser.parse_args()
    if FLAG.exists() and not args.preview:
        return
    if not PYTHON.exists():
        raise SystemExit("Arcade environment missing; see the experiment arcade ledger.")
    process = subprocess.Popen([
        "kitty", "--config", "NONE", "--class", "charcoal-screensaver",
        "--title", "Midnight Maze", "--start-as", "fullscreen",
        "-o", "background=#080d17", "-o", "font_size=16",
        "-o", "cursor_blink_interval=0", "-o", "enable_audio_bell=no",
        "-o", "background_opacity=1", "-o", "confirm_os_window_close=0",
        "-o", "shell_integration=disabled",
        str(PYTHON), str(ROOT / "scripts/arcade-maze.py"),
    ])
    process.wait()
    if process.returncode:
        raise SystemExit(process.returncode)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
