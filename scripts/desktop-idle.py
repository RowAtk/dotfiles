#!/usr/bin/env python3
"""Dispatch Hypridle actions according to the active desktop profile."""
import argparse
from pathlib import Path
import subprocess

FLAG = Path.home() / ".local/state/charcoal-copper/boring"


def run(*args):
    return subprocess.run(args, check=False, timeout=15)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["idle", "resume", "off"])
    action = parser.parse_args().action
    if action == "idle":
        if FLAG.exists():
            run("systemctl", "--user", "start", "charcoal-idle-dim.service")
        else:
            run("systemctl", "--user", "start", "--no-block", "charcoal-screensaver.service")
    else:
        run("systemctl", "--user", "stop", "charcoal-screensaver.service",
            "charcoal-idle-dim.service")
        state = "on" if action == "resume" else "off"
        run("hyprctl", "dispatch", 'hl.dsp.dpms({action = "' + state + '"})')


if __name__ == "__main__":
    main()
