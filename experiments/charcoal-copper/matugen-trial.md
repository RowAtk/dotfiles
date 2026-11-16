# Wallpaper Palette Trial

Installed matugen 4.2.0-1 explicitly on 2026-11-16; immediate before/after
package comparison recorded only matugen added, no existing package upgrades.
Baseline package, explicit and orphan lists are retained with the matugen suffix.
Matugen runs only on wallpaper/theme changes; no new background daemon.

## Controls

Experimental Waybar wallpaper button: left click chooses a random wallpaper and
applies its dark palette; right click restores copper without changing wallpaper.
python3 scripts/desktop-theme.py IMAGE applies a chosen image and its colours.
python3 scripts/desktop-theme.py --copper restores the approved palette.
--prepare generates files without setting wallpaper or reloading services.

The generator uses Matugen 4 JSON output and standard-library string templates.
It runs Matugen with a dedicated empty-template config and --dry-run so no
unrelated Matugen wallpaper hooks or templates execute. Generation is serialized.
Source templates are in templates/. Outputs are under:
~/.local/state/charcoal-copper/{waybar.css,swaync.css,kitty.conf,palette.lua,palette.json}
The current-wallpaper file records successful wallpaper applications.

Waybar now reads its stylesheet from that state directory; its layout remains
in this worktree. Live SwayNC style imports the generated CSS. Kitty includes a
separate colour override, preserving its original theme.conf symlink and target.
Hyprland Lua loads generated border colours, with copper fallback if absent.
No application restart or logout. No persistent startup changes made in this trial.

## Validation

Generated current landscape palette and applied to wallpaper and all four UI
components. Hyprland reload succeeded and subsequent configerrors was empty.
SwayNC CSS reload returned true. Waybar configured at 1896x38 without parse errors.
Copper reset was tested separately without changing wallpaper.

## Rollback

Pre-palette live files are in:
~/.local/state/wm-palette-backup.PjNu8BHU/{hyprland.lua,kitty.conf,swaync.css}
Compare files for later edits before restoring each to its original config path.
Reload Hyprland config-only and Kitty via USR1. Reload SwayNC CSS.
Restart exactly one Waybar using this worktree's static style.css instead of
the generated state stylesheet. Restore wallpaper separately if desired.
Remove generated state files only after removing imports or stopping consumers.
Optional package cleanup: remove matugen if unused elsewhere; no new dependencies.
Do not remove existing packages or unrelated orphans.
