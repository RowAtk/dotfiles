# Midnight Maze trial

2026-11-16: replaced the falling-letter prototype with an original,
self-playing Pac-Man-inspired maze. Random connected layouts, four ghosts,
pellets, power pellets, lives and automatic new rounds. All artwork is drawn
locally with Pillow; no downloaded game assets or ROMs. NetworkX supplies maze
graph construction and pathfinding. Rendered at 20 FPS using Kitty graphics.

Native Wayland fullscreen Kitty is launched only during idle. Existing five-minute
idle, fifteen-minute display-off and resume rules remain. Boring uses dim/off
and stops the managed saver. This is an animation, with no session locking.

## Packages

No system packages installed or upgraded for this step. Existing system Python,
Pillow 13.0.0 and psutil 7.2.2 retained. Created isolated environment:
~/.local/share/charcoal-arcade/venv (with system site packages).
Installed only NetworkX 3.7 there, pinned in arcade-requirements.txt.
Recreate after a system Python major/minor upgrade if the environment breaks:

    python3 -m venv --system-site-packages ~/.local/share/charcoal-arcade/venv
    ~/.local/share/charcoal-arcade/venv/bin/pip install --no-deps -r ~/projects/wm-charcoal-copper/experiments/charcoal-copper/arcade-requirements.txt

## Preview and validation

In a visual profile:

    systemctl --user start charcoal-screensaver.service
    systemctl --user stop charcoal-screensaver.service

Explicit preview even while Boring is manually selected (any key closes it):

    python3 ~/projects/wm-charcoal-copper/scripts/desktop-screensaver.py --preview

Normal idle activation is supervised by the service; use that path for everyday
operation. The explicit preview bypasses Boring on purpose and is not managed
by its stop hook.

Seven focused simulation/policy tests passed. A bounded live preview confirmed
1920x1080 fullscreen and xwayland=false, without game errors. Preview stopped.
Rendered screenshot: /tmp/charcoal-arcade-preview.png (temporary).
Real idle/input dismissal still merits user confirmation. No settled resource
benchmark recorded for this renderer; prototype costs do not describe this game.

## Cleanup

Stop charcoal-screensaver.service before removing its renderer or environment.
Remove only ~/.local/share/charcoal-arcade/venv if retiring this experiment.
Keep pre-existing system Pillow, Python and psutil. Restore the former renderer
from commit 439bc45 only if desired, or follow screensaver-trial.md idle rollback.
No package-manager uninstall is needed. No changes to other project environments.
