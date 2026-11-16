# Synchronized Wallpaper Rotation

Enabled charcoal-wallpaper.timer in the systemd user manager.
First run is ten minutes after timer activation, then ten minutes after each
service activation. It belongs to graphical-session.target and stops with it.
The service invokes this experiment worktree's desktop-theme.py --random.
Hyprland Lua autostart imports WAYLAND_DISPLAY and HYPRLAND_INSTANCE_SIGNATURE
into the user manager, then restores the selected desktop profile. The Wallpaper
profile starts this timer; Copper and Boring stop it.
Starting an already-active systemd timer does not create a duplicate timer.
Session variables WAYLAND_DISPLAY and HYPRLAND_INSTANCE_SIGNATURE must exist
in the user manager (verified for the current session).

Hyprpaper's fallback now uses a single image, disabling its independent
30-second directory rotation. Original config backup:
~/.local/state/wm-palette-backup.PjNu8BHU/hyprpaper.conf
Hyprpaper was restarted once; its PID and other apps were not restarted together.
Theme changes apply the same image to every connected output and update UI colours.
The last image is excluded when alternatives exist. Only regular image files qualify.
No packages added.

Manual service test completed with Result=success and ExecMainStatus=0.
Timer next-run time was verified and hyprctl configerrors was empty afterward.

Pause: systemctl --user stop charcoal-wallpaper.timer
Resume: systemctl --user start charcoal-wallpaper.timer
Rotate immediately: systemctl --user start charcoal-wallpaper.service
Disable permanently: systemctl --user disable --now charcoal-wallpaper.timer

Right-click copper reset lasts until the next manual or scheduled theme change.
Pause the timer to retain copper indefinitely.

Rollback: disable timer first, stop the oneshot service if active, preserve any
subsequent edits and remove the charcoal-wallpaper.timer startup command from
the live Hyprland Lua config. Otherwise the next Hyprland startup starts it again.
Restore backed-up hyprpaper.conf after checking for later edits, then restart Hyprpaper.
Remove only the two new charcoal-wallpaper user units, then daemon-reload.
Keep the experiment worktree while its service is installed; the unit refers to it.
Live user-unit files and hyprpaper config are experimental home changes, not merged.
