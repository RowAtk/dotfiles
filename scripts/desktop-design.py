#!/usr/bin/env python3
"""Select a desktop profile; read Git snapshots without touching any checkout."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent.parent
STATE = Path.home() / ".local/state/charcoal-copper"
REGISTRY = ROOT / "experiments/charcoal-copper/designs.json"


def run(args, check=True, **kwargs):
    return subprocess.run(args, check=check, text=True, timeout=90, **kwargs)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("design", nargs="?")
    parser.add_argument("--restore", action="store_true")
    parser.add_argument("--list", action="store_true")
    args = parser.parse_args()
    designs = json.loads(REGISTRY.read_text())
    if args.list:
        print("\n".join(d["id"] + ": " + d["description"] for d in designs))
        return
    STATE.mkdir(parents=True, exist_ok=True)
    selected = STATE / "design"
    choice = args.design
    if args.restore:
        choice = selected.read_text().strip() if selected.exists() else "wallpaper"
    if not choice:
        command = ["zenity", "--list", "--title=Desktop Designs", "--width=760",
                   "--height=330", "--column=ID", "--column=Design",
                   "--column=Description", "--hide-column=1", "--print-column=1"]
        for design in designs:
            command.extend([design["id"], design["name"], design["description"]])
        result = run(command, check=False, capture_output=True)
        if result.returncode:
            return
        choice = result.stdout.strip()
    design = next((d for d in designs if d["id"] == choice), None)
    if not design:
        raise SystemExit("Unknown desktop design: " + choice)
    with (STATE / "design.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        mode = [sys.executable, str(ROOT / "scripts/desktop-mode.py")]
        # Explicit profiles decide timer state; direct leaf toggles preserve it.
        run(mode + ["--boring" if choice == "boring" else "--normal"])
        if choice == "wallpaper":
            current = STATE / "current-wallpaper"
            image = current.read_text().strip() if current.exists() else str(Path.home() / "wallpapers/landscape.jpg")
            run([sys.executable, str(ROOT / "scripts/desktop-theme.py"), image])
            run(["systemctl", "--user", "start", "charcoal-wallpaper.timer"])
        else:
            run(["systemctl", "--user", "stop", "charcoal-wallpaper.timer"])
            if choice != "boring":
                run([sys.executable, str(ROOT / "scripts/desktop-theme.py"), "--copper"])
        config = ROOT / ".config/waybar/config.jsonc"
        style = STATE / "waybar.css"
        if "ref" in design:
            snapshot = STATE / design["id"]
            snapshot.mkdir(exist_ok=True)
            for key, name in (("config", "config.jsonc"), ("style", "style.css")):
                result = run(["git", "--git-dir=" + str(Path.home() / ".cfg"),
                              "show", design["ref"] + ":" + design[key]], capture_output=True)
                text = result.stdout
                if key == "config":
                    # Snapshot visuals share the permanent compositor reservation.
                    text = text.replace("{", '{\n    "exclusive": false,\n    "reload_style_on_change": true,', 1)
                    text = text.replace('"margin-top": 8', '"margin-top": -38', 1)
                (snapshot / name).write_text(text)
            config, style = snapshot / "config.jsonc", snapshot / "style.css"
        command = ["waybar", "-c", str(config), "-s", str(style)]
        pids = run(["pgrep", "-x", "waybar"], check=False, capture_output=True).stdout.split()
        unchanged = False
        if len(pids) == 1:
            try:
                unchanged = (Path("/proc") / pids[0] / "cmdline").read_bytes().split(b"\0")[:-1] == [arg.encode() for arg in command]
            except FileNotFoundError:
                pass
        if not unchanged:
            run(["pkill", "-x", "waybar"], check=False)
            for _ in range(30):
                if run(["pgrep", "-x", "waybar"], check=False, capture_output=True).returncode:
                    break
                time.sleep(0.1)
            else:
                raise SystemExit("Waybar did not stop; refusing to start a duplicate.")
            with (STATE / "waybar.log").open("a") as log:
                process = subprocess.Popen(command, stdin=subprocess.DEVNULL,
                                           stdout=log, stderr=log, start_new_session=True)
            time.sleep(1)
            if process.poll() is not None:
                raise SystemExit("Waybar failed; inspect " + str(STATE / "waybar.log"))
        temporary = STATE / "design.tmp"
        temporary.write_text(choice + "\n")
        os.replace(temporary, selected)
        print("Desktop design:", choice)


if __name__ == "__main__":
    main()
