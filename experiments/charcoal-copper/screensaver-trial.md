# Profile-aware Animated Screensaver

The falling-character prototype has been replaced by Midnight Maze, a custom
Pac-Man-inspired attract mode. See arcade-trial.md for dependencies, preview,
validation and cleanup. The idle/service behavior below remains unchanged.
No session locking or password prompt.

At five minutes of idle:
- Visual profiles start charcoal-screensaver.service.
- Boring starts charcoal-idle-dim.service (hyprsunset gamma 65, 3800 K).
At fifteen minutes both profiles stop idle effects and turn displays off.
Activity stops both effect services and turns displays on.
The hypridle idle inhibitor remains respected through its default behavior.

The animation's Kitty window exits on a key; hypridle on-resume dismisses it
on pointer/keyboard activity. The service cgroup owns the Kitty and Python
children, so stop cleans up the whole saver. It runs only on the current display;
tested on the machine's sole HDMI-A-2 monitor, not a multi-monitor configuration.
Switching desktop modes stops any active saver and dimmer.

Hypridle was migrated from PID 1211 (unmanaged) to hypridle.service.
Hyprland startup now starts that user service after importing Wayland variables.
No service enablement changes: Hyprland autostart handles future sessions.
The old persistent gamma-65 hyprsunset process (PID 8956) came from the previous
idle commands and was stopped. Dimming now has a managed lifetime, so resume
does not launch another persistent hyprsunset instance.

## Validation and Resource Cost

Python syntax and systemd unit verification passed.
Two bounded previews launched; Hyprland reported fullscreen=2, xwayland=false,
and dimensions 1920x1080. Preview service stopped with no remaining saver children.
The original falling-character prototype's eight-second preview reached 127 MiB service memory peak and consumed about
1.0 CPU-second including initialization. This is not a settled CPU benchmark;
the animated mode is materially heavier than dim/display-off and is opt-in
through choosing a visual profile. No animation worker runs during normal use.
Boring service test exited successfully without a window.
Dim start/resume test passed; both effect services ended inactive.
Hypridle registered both rules, and hyprctl configerrors was empty.
The 15-minute physical screen-off action was not forced during testing.
Real input dismissal should be confirmed by the user on the next idle cycle.

## Controls

In a visual profile, preview using:
systemctl --user start charcoal-screensaver.service
Dismiss by moving the mouse (when activated by hypridle), pressing a key,
or systemctl --user stop charcoal-screensaver.service.
In Boring mode the saver service intentionally exits without opening a window.

## Rollback

Original idle config is preserved at:
~/.local/state/wm-palette-backup.PjNu8BHU/hypridle.conf
Check for later edits, restore that config and restart hypridle.service.
Stop charcoal-screensaver.service and charcoal-idle-dim.service, then remove
only these new unit files and run systemctl --user daemon-reload.
Remove their stop hooks from desktop-mode.py if removing the units.
Preserve managed hypridle startup or deliberately restore its prior direct launch.
For the replacement arcade renderer, also follow arcade-trial.md dependency cleanup.
