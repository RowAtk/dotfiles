#!/usr/bin/env python3
"""Idle-only terminal animation; no session locking or resident worker."""
import argparse
import curses
from pathlib import Path
import random
import subprocess
import sys
import time

FLAG = Path.home() / ".local/state/charcoal-copper/boring"


def animate(screen):
    curses.curs_set(0)
    screen.nodelay(True)
    curses.start_color()
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_WHITE, curses.COLOR_BLACK)
    streams = []
    previous_size = None
    while True:
        if screen.getch() != -1:
            return
        rows, cols = screen.getmaxyx()
        if previous_size != (rows, cols):
            streams = [[x, random.randrange(-rows, 0), random.randrange(5, 14)]
                       for x in range(2, cols - 2, 4)]
            previous_size = (rows, cols)
        screen.erase()
        for stream in streams:
            x, head, length = stream
            for depth in range(length):
                y = head - depth
                if 0 <= y < rows - 1:
                    char = random.choice("0123456789ABCDEF:+*")
                    attr = curses.color_pair(2 if depth == 0 else 1)
                    if depth > length // 2:
                        attr |= curses.A_DIM
                    screen.addch(y, x, char, attr)
            stream[1] = head + 1 if head - length < rows else random.randrange(-rows, 0)
        screen.refresh()
        time.sleep(0.125)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--preview", action="store_true")
    parser.add_argument("--animate", action="store_true")
    args = parser.parse_args()
    if args.animate:
        curses.wrapper(animate)
        return
    if FLAG.exists() and not args.preview:
        return
    # Kitty creates a native Wayland window. Its process and animation belong to
    # the service cgroup, so stopping the service cleans up both.
    process = subprocess.Popen([
        "kitty", "--config", "NONE", "--class", "charcoal-screensaver",
        "--title", "Charcoal Screensaver", "--start-as", "fullscreen",
        "-o", "background=#101012", "-o", "foreground=#79b8ad",
        "-o", "font_size=22", "-o", "cursor_blink_interval=0",
        "-o", "enable_audio_bell=no", "-o", "background_opacity=1",
        "-o", "confirm_os_window_close=0", "-o", "shell_integration=disabled",
        sys.executable, str(Path(__file__).resolve()), "--animate",
    ])
    process.wait()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
