#!/usr/bin/env python3
"""Stream Spotify metadata to Waybar, scrolling only labels that overflow."""

import html
import json
import subprocess
import time
import unicodedata


WIDTH = 36
STEP = 0.35
HOLD = 6


def cells(char):
    if unicodedata.combining(char):
        return 0
    return 2 if unicodedata.east_asian_width(char) in ("W", "F") else 1


def clip(text, width):
    result = ""
    used = 0
    for char in text:
        size = cells(char)
        if used + size > width:
            break
        result += char
        used += size
    return result


def query(*args):
    try:
        result = subprocess.run(
            ["playerctl", "--player=spotify", *args],
            capture_output=True, text=True, timeout=2, check=False,
        )
        return result.stdout.strip() if result.returncode == 0 else ""
    except (subprocess.TimeoutExpired, OSError):
        return ""


def main():
    previous = None
    label = ""
    status = ""
    offset = 0
    hold = HOLD
    refresh_at = 0
    while True:
        now = time.monotonic()
        if now >= refresh_at:
            status = query("status")
            metadata = query("metadata", "--format", "{{title}}\n{{artist}}")
            parts = [" ".join(part.split()) for part in metadata.splitlines()]
            label = " — ".join(part for part in parts if part)
            identity = label
            if identity != previous:
                offset, hold = 0, HOLD
                previous = identity
            refresh_at = now + 2

        if not label or status == "Stopped":
            output = {"text": "", "tooltip": "", "class": "stopped"}
        else:
            long = sum(cells(char) for char in label) > WIDTH
            # Repeat with a gap so a long label wraps without an abrupt jump.
            ring = label + "     " + label
            visible = clip(ring[offset:], WIDTH) if long else label
            icon = "" if status == "Playing" else ""
            output = {
                "text": html.escape(icon + " " + visible),
                "tooltip": html.escape(label),
                "class": status.lower(),
            }
            if long:
                if hold:
                    hold -= 1
                else:
                    offset += 1
                    if offset >= len(label) + 5:
                        offset, hold = 0, HOLD

        print(json.dumps(output, ensure_ascii=False), flush=True)
        time.sleep(STEP)


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        pass
