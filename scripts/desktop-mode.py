#!/usr/bin/env python3
"""Toggle a persistent low-effects desktop profile without closing applications."""
import argparse
import fcntl
import json
from pathlib import Path
import struct
import subprocess
import time
import zlib

ROOT = Path(__file__).resolve().parent.parent
STATE = Path.home() / ".local/state/charcoal-copper"
FLAG = STATE / "boring"
SAVED = STATE / "mode-restore.json"
TIMER = "charcoal-wallpaper.timer"


def run(args, check=True):
    return subprocess.run(args, text=True, capture_output=True, timeout=60, check=check)


def solid_png():
    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))
    data = b"\x89PNG\r\n\x1a\n"
    data += chunk(b"IHDR", struct.pack(">IIBBBBB", 1, 1, 8, 2, 0, 0, 0))
    data += chunk(b"IDAT", zlib.compress(bytes([0, 24, 24, 26])))
    data += chunk(b"IEND", b"")
    path = STATE / "solid.png"
    path.write_bytes(data)
    return path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--restore", action="store_true")
    parser.add_argument("--status", action="store_true")
    parser.add_argument("--boring", action="store_true")
    parser.add_argument("--normal", action="store_true")
    args = parser.parse_args()
    STATE.mkdir(parents=True, exist_ok=True)
    if args.status:
        boring = FLAG.exists()
        print(json.dumps({"text": "" if boring else "",
                          "class": "boring" if boring else "normal",
                          "tooltip": "Boring mode: " + ("on" if boring else "off")}))
        return
    lock = (STATE / "lock").open("w")
    fcntl.flock(lock, fcntl.LOCK_EX)
    boring = FLAG.exists() if args.restore else args.boring or (not args.normal and not FLAG.exists())
    if boring:
        if not FLAG.exists():
            enabled = run(["systemctl", "--user", "is-active", TIMER], check=False).returncode == 0
            selected = STATE / "design"
            design = selected.read_text().strip() if selected.exists() else "wallpaper"
            SAVED.write_text(json.dumps({"timer_active": enabled, "design": design}))
            FLAG.write_text("1\n")
            selected.write_text("boring\n")
        run(["systemctl", "--user", "stop", TIMER])
        image = solid_png()
    else:
        if FLAG.exists() and SAVED.exists():
            previous = json.loads(SAVED.read_text())
            (STATE / "design").write_text(previous.get("design", "wallpaper") + "\n")
        FLAG.unlink(missing_ok=True)
        current = STATE / "current-wallpaper"
        image = Path(current.read_text().strip()) if current.exists() else Path.home() / "wallpapers/landscape.jpg"
        if not image.is_file():
            image = solid_png()
    if "\n" in str(image):
        raise SystemExit("Unsupported newline in wallpaper path.")
    config = STATE / "hyprpaper-mode.conf"
    config.write_text("splash = false\nwallpaper {\n    monitor =\n    path = " + str(image) + "\n    fit_mode = cover\n}\n")
    # Restart just the wallpaper daemon to release decoded images retained in memory.
    run(["pkill", "-x", "hyprpaper"], check=False)
    for _ in range(30):
        if run(["pgrep", "-x", "hyprpaper"], check=False).returncode != 0:
            break
        time.sleep(0.1)
    else:
        raise SystemExit("Hyprpaper did not stop; refusing to start a duplicate.")
    with (STATE / "hyprpaper.log").open("a") as log:
        subprocess.Popen(["hyprpaper", "-c", str(config)],
                         stdin=subprocess.DEVNULL, stdout=log, stderr=log,
                         start_new_session=True)
    run(["hyprctl", "reload", "config-only"])
    if not boring:
        saved = json.loads(SAVED.read_text()) if SAVED.exists() else {"timer_active": True}
        if saved["timer_active"]:
            run(["systemctl", "--user", "start", TIMER])
    print("Boring mode:", "on" if boring else "off")


if __name__ == "__main__":
    main()
