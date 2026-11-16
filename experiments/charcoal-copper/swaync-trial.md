# SwayNC Trial

Installed 2026-11-16 by user-authenticated pacman transaction.
Added swaync 0.12.6-2 (explicit), gtk4-layer-shell 1.3.0-1 (dependency),
and libgee 0.20.8-1 (dependency). No pre-existing package versions changed.
Immediate pre-install package, explicit and orphan lists are preserved here.

Dunst 1.13.2-3 was active as static dunst.service. Stopped it and started
swaync.service. Neither service enablement changed: session-only trial.
New live ~/.config/swaync/config.json and style.css match worktree copies.
No old SwayNC user config existed. Other application configs were untouched.

Config and CSS loaded without errors; title, DND, volume, media and history
widgets loaded. Test notification count returned 1 and panel opened.
Waybar bell toggles panel on left click and DND on right click.

Main-process measurements (not service cgroups):
- Dunst: RSS 32156 KiB, lifetime CPU 0.0%, elapsed 17671 seconds.
- SwayNC after panel opened: RSS 92640 KiB, lifetime CPU 5.1%, elapsed 55 seconds.
The latter includes startup/UI work and is not a settled idle CPU comparison.

## Rollback and Cleanup

Run systemctl --user stop swaync.service, then
systemctl --user start dunst.service.
Restore original Waybar or remove its new notification module and reload.
Archive/remove only newly created ~/.config/swaync files after checking for
subsequent user edits. Dunst configuration and package remain intact.
Optionally uninstall swaync; review gtk4-layer-shell and libgee for other
dependents before removing them. Do not remove unrelated or pre-existing orphans.
Persistent startup selection is deferred until the panel is accepted.
