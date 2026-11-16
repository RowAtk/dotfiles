# Automatic Boring mode

2026-11-16: charcoal-resource-guard.service is enabled and running, and Hyprland
Lua startup explicitly starts it after importing session environment variables.
No new system packages: uses pre-existing system psutil 7.2.2.

Configuration: experiments/charcoal-copper/resource-guard.json.
Samples every five seconds. Either total-system CPU >=95% OR memory pressure
>=90% for three consecutive samples enters Boring. CPU means all cores combined;
memory uses total minus available, allowing reclaimable filesystem cache.

Automatic Boring stays on at least 90 seconds. Both CPU <75% and memory <80%
for 60 continuous seconds restore the preceding design and wallpaper behavior.
These lower recovery thresholds prevent repeated switching near the limit.
The 15-second trigger is approximate because samples are five seconds apart.
Manually selected Boring is never automatically released. Manually returning
to a visual profile allows the guard to trigger again if pressure persists.

Existing Boring behavior stops animated idle, pauses wallpaper rotation, uses
a solid wallpaper and disables compositor effects. It does not kill applications.
It cannot guarantee enough resources if the load comes from unrelated programs.

## Inspection and tuning

    systemctl --user status charcoal-resource-guard.service
    journalctl --user -u charcoal-resource-guard.service -n 20
    cat ~/.local/state/charcoal-copper/resource-guard.json

Edit the configuration and restart the service to change thresholds:

    systemctl --user restart charcoal-resource-guard.service

Policy transitions, spike rejection, manual ownership, minimum hold and recovery
were tested with synthetic samples. No artificial CPU/RAM stress imposed on the
live desktop. Live service runs at roughly 10 MiB on initial inspection.
Hyprland config-only reload succeeded; subsequent configerrors was empty.

## Cleanup

    systemctl --user disable --now charcoal-resource-guard.service

Also remove the explicit charcoal-resource-guard.service start from the startup
command in ~/.config/hypr/hyprland.lua and its experiment copy, or the next login
will start it again. Remove only the new unit and run systemctl --user daemon-reload.
If currently automatically Boring, select the desired design first. The guard
itself does not change modes when stopped. Keep existing psutil installed.
