# Stable Waybar spacing and icon refresh

2026-11-16: Hyprland's Lua monitor rule reserves 46 logical pixels at the top
(38-pixel bar plus 8-pixel top margin). Waybar uses exclusive=false, so stopping
or rebuilding its layer surface no longer changes the tiled work area. The
reservation also remains when the bar is hidden. Future themes should fit in
this strip or deliberately update the shared reservation.

The Classic Git snapshot gets the same non-exclusive override when materialized;
the original Git snapshot is unchanged. Live home Waybar config is an older
snapshot, left untouched; the running experiment explicitly loads the worktree
config. Home and worktree Hyprland Lua both contain the permanent reservation.

reload_style_on_change=true enables CSS-only updates. desktop-theme.py no
longer sends SIGUSR2 to Waybar. Its generated CSS is written in place, preserving
the inode monitored by Gio; other generated files retain atomic replacement.
Desktop profiles sharing the current config/style paths keep the existing bar
process. A switch to/from Classic still restarts Waybar with its different files.
Config/module edits still require a reload; the permanent reservation protects
windows during those reloads too.

Icons now consistently use Material Design glyphs from the already-installed
JetBrainsMono Nerd Font: palette, wallpaper, bell states, system drawer, audio,
network, Bluetooth, idle, CPU/RAM, clock, power and media controls. Existing theme
colours and numeric widths retained; no additional packages or icon daemon.
Glyph names verified against the Nerd Fonts upstream glyphnames.json.

Validation: all four tiled clients kept identical positions and dimensions
after initial setup, while Waybar was stopped, and after restart. Reserved area
remained [0,46,0,0]. Reapplying the current Wallpaper Colours profile retained
Waybar's PID and client geometry. Exactly one bar remained; configerrors empty.

Rollback: remove reserved_area from both Lua copies AND restore exclusive=true
(or remove the false override) for the experiment and generated Classic config.
Reload compositor and bar together. Removing only the reservation allows windows
to overlap the bar; removing only the exclusive override doubles the gap.
Pre-change live Lua backup: ~/.local/state/charcoal-copper/hyprland-before-fixed-bar.lua.
Inspect for subsequent edits before restoring. No package cleanup needed.
