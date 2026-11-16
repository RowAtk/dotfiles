#!/usr/bin/env python3
"""Generate the experiment palette on demand and refresh existing desktop services."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import random
import re
from string import Template
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
HOME = Path.home()
STATE = HOME / ".local/state/charcoal-copper"
COPPER = dict(bg="#18181a", surface="#262526", fg="#e4ded7",
              primary="#d99a73", secondary="#79b8ad", muted="#9e9893",
              outline="#494039", error="#e38d91")


def run(args, **kwargs):
    return subprocess.run(args, check=True, text=True, timeout=45, **kwargs)


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as file:
        file.write(text)
        name = file.name
    os.replace(name, path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("image", nargs="?", type=Path)
    parser.add_argument("--random", action="store_true")
    parser.add_argument("--copper", action="store_true")
    parser.add_argument("--prepare", action="store_true")
    args = parser.parse_args()
    STATE.mkdir(parents=True, exist_ok=True)
    lock = (STATE / "lock").open("w")
    fcntl.flock(lock, fcntl.LOCK_EX)
    if (STATE / "boring").exists() and not args.prepare:
        print("Boring mode is active; theme rotation skipped.")
        return
    current = STATE / "current-wallpaper"
    image = args.image.expanduser().resolve() if args.image else None
    if args.random:
        images = [p for p in (HOME / "wallpapers").iterdir()
                  if p.is_file() and p.suffix.lower() in (".jpg", ".jpeg", ".png", ".webp")]
        previous = current.read_text().strip() if current.exists() else ""
        choices = [p for p in images if str(p) != previous] or images
        if not choices:
            raise SystemExit("No wallpaper images found.")
        image = random.choice(choices)
    colors = COPPER.copy()
    if not args.copper:
        if not image or not image.is_file():
            raise SystemExit("Provide an image, --random, or --copper.")
        result = run(["matugen", "-c", str(ROOT / "experiments/charcoal-copper/matugen.toml"),
                      "--dry-run", "-j", "hex", "--source-color-index", "0",
                      "image", str(image)], capture_output=True)
        palette = json.loads(result.stdout)["colors"]
        roles = dict(bg="surface", surface="surface_container", fg="on_surface",
                     primary="primary", secondary="tertiary", muted="outline",
                     outline="outline_variant", error="error")
        colors = {key: palette[role]["dark"]["color"] for key, role in roles.items()}
    if not all(re.fullmatch(r"#[0-9a-fA-F]{6}", value) for value in colors.values()):
        raise SystemExit("Invalid generated palette; current theme preserved.")
    for key in ("bg", "primary", "surface"):
        colors[key + "_rgb"] = ", ".join(str(int(colors[key][i:i+2], 16)) for i in (1, 3, 5))
    rendered = {}
    for name in ("waybar.css", "swaync.css"):
        template = (ROOT / "experiments/charcoal-copper/templates" / name).read_text()
        rendered[name] = Template(template).substitute(colors)
    if image and not args.prepare and not args.copper:
        monitors = json.loads(run(["hyprctl", "-j", "monitors"], capture_output=True).stdout)
        for monitor in monitors:
            run(["hyprctl", "hyprpaper", "wallpaper", f"{monitor['name']},{image},cover"])
        write(current, str(image) + "\n")
    for name, value in rendered.items():
        write(STATE / name, value)
    kitty = "\n".join([
        "background " + colors["bg"], "foreground " + colors["fg"],
        "cursor " + colors["primary"], "selection_background " + colors["primary"],
        "selection_foreground " + colors["bg"],
        "color0 " + colors["bg"], "color8 " + colors["muted"],
        "color1 " + colors["error"], "color9 " + colors["error"],
        "color2 " + colors["secondary"], "color10 " + colors["secondary"],
        "color3 " + colors["primary"], "color11 " + colors["primary"],
        "color4 " + colors["secondary"], "color12 " + colors["secondary"],
        "color5 " + colors["primary"], "color13 " + colors["primary"],
        "color6 " + colors["secondary"], "color14 " + colors["secondary"],
        "color7 " + colors["fg"], "color15 " + colors["fg"], ""])
    write(STATE / "kitty.conf", kitty)
    lua = "return " + "{ primary = " + json.dumps(colors["primary"]) + ", secondary = " + json.dumps(colors["secondary"]) + " }\n"
    write(STATE / "palette.lua", lua)
    write(STATE / "palette.json", json.dumps(colors, indent=2) + "\n")
    if not args.prepare:
        run(["hyprctl", "reload", "config-only"])
        for command in (["pkill", "-USR2", "-x", "waybar"],
                        ["pkill", "-USR1", "-x", "kitty"],
                        ["swaync-client", "-rs", "-sw"]):
            subprocess.run(command, timeout=10, check=False)
        print("Theme applied:", "copper" if args.copper else image.name)


if __name__ == "__main__":
    main()
