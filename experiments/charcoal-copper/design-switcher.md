# Desktop Designs and Boring Mode

Open the palette button beside the wallpaper button, or press SUPER+ALT+T.
The leaf/power-profile button toggles Boring mode directly.
CLI: python3 scripts/desktop-design.py {copper,wallpaper,boring,classic}
CLI toggle: python3 scripts/desktop-mode.py

## Profiles

- Copper: current three-section design, fixed copper palette, rotation stopped.
- Wallpaper Colours: current design, image-derived palette, ten-minute timer.
- Boring: solid 1x1 charcoal image, wallpaper rotation stopped, no compositor
  blur, shadows, or animations, opaque application windows, static media label.
- Classic Bar: original bar config/style read from commit 6a4c70c with git show.
  Current Linux keybindings and the compositor design are retained.

This is an initial profile switcher, not yet an archive of several complete
desktop environments. Registry: designs.json. Future designs can add Git-backed
bar snapshots and reuse the low-effects profile. Never check out the home repo
to switch themes: doing so would change live files and unrelated config edits.

Selected profile and mode state are in ~/.local/state/charcoal-copper/.
Hyprland startup imports the session environment and calls desktop-design.py
--restore. The helper restores one wallpaper process and one selected Waybar.
Direct Boring toggles remember the previous profile/timer state; disabled
wallpaper rotation is restored only when it was previously active.
Theme generation checks the shared Boring marker and skips image/colour changes.
Media refreshes every two seconds without scrolling in Boring mode.
Notifications, volume, media playback, and applications continue to work.

## Resource Cost and Validation

No packages or persistent helper daemons added; zenity, Python and Git existed.
Wallpaper daemon is restarted on profile changes to release retained decoded
image buffers. It stays running to paint the solid background.
Observed hyprpaper RSS before Boring: 233548 KiB (~228 MiB).
After Boring: 103004 KiB (~101 MiB), saving roughly 128 MiB in this sample.
No claim that all of that saving is guaranteed on other displays or images.
SwayNC remains about 68 MiB; it is retained for functionality.
Detailed wallpaper palettes still invoke Matugen periodically in Wallpaper mode.
Blur and shadows are GPU work; disabling them does not imply a specific RAM saving.

Tested Classic -> Wallpaper -> Boring; each bar launched successfully.
Final live getoption checks: animations.enabled, decoration.blur.enabled and
decoration.shadow.enabled all false, wallpaper timer inactive, configerrors empty.
One wallpaper process and one bar confirmed. Final mode: Boring.

## Rollback

Choose Copper or Wallpaper Colours to leave Boring. SUPER+ALT+T is also available
when the Classic bar has no theme button. Theme switches read Git, never commit,
merge, reset, or alter the other agent's project.
To remove the experiment, first stop the rotation timer and follow the existing
backup ledgers; remove the profile startup helper and shortcut from live Lua.
Restore original wallpaper startup and bar startup before removing this worktree.
Retain state files until all consumers and imports have been removed.
