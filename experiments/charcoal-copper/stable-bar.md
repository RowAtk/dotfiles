# Stable Waybar spacing and icon refresh

2026-11-16: Hyprland's Lua monitor rule reserves 46 logical pixels at the top
(38-pixel bar plus 8-pixel top margin). Waybar uses exclusive=false, so stopping
or rebuilding its layer surface no longer changes the tiled work area. The
reservation also remains when the bar is hidden. Future themes should fit in
this strip or deliberately update the shared reservation.

Non-exclusive layers are positioned relative to the remaining work area on
this Hyprland version. Waybar therefore uses margin-top=-38 (8 minus the 46px
reservation), placing its actual top at y=8. The same compensation is applied
to generated Classic config. An initial margin of 8 incorrectly placed the bar
at y=54; corrected after user feedback and verified against hyprctl layers.

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

Follow-up: hide nm_applet/nm-applet and blueman tray items by targeted ignore-list
entries. Dedicated network/Bluetooth modules remain. Applets remain running for
authentication and pairing; unrelated application tray icons remain visible.
Network now uses four signal-strength glyphs and Bluetooth a distinct connected
glyph. Both render at 16px, with connected Bluetooth using the secondary colour.
Undo by removing only these ignore-list entries and restoring their module/CSS
formats. No startup/service/package changes for this cleanup. Classic remains
the original snapshot and is intentionally not given the experiment's widgets.

Icon alignment follow-up: Pango measurements at 16px showed the patched
JetBrainsMono font reporting a 10px advance for a Wi-Fi glyph with 16px ink.
Equal module padding did not fix that overhang. Standalone icon modules now
explicitly use the existing Symbols Nerd Font, whose glyph advances match the
actual symbol widths. Audio and media embed the same icon font at 12pt (16px)
with Pango markup while retaining the existing text font and numeric widths.
Application tray artwork is in a hover drawer behind the ellipsis button;
expand it to access the original application menus. Duplicate network tray
filters remain. No new font packages installed. Config/Pango parsing passed;
bar remains y=8,height=38 with unchanged tiled geometry and no config errors.

Validation: all four tiled clients kept identical positions and dimensions
after initial setup, while Waybar was stopped, and after restart. Reserved area
remained [0,46,0,0]. Reapplying the current Wallpaper Colours profile retained
Waybar's PID and client geometry. Exactly one bar remained; configerrors empty.
After offset correction, the bar rectangle is x=12,y=8,w=1896,h=38, and all
tiled client positions and sizes remain unchanged across the config reload.

Rollback: remove reserved_area from both Lua copies AND restore exclusive=true
(or remove the false override) for the experiment and generated Classic config.
Restore margin-top=8 at the same time.
Reload compositor and bar together. Removing only the reservation allows windows
to overlap the bar; removing only the exclusive override doubles the gap.
Pre-change live Lua backup: ~/.local/state/charcoal-copper/hyprland-before-fixed-bar.lua.
Inspect for subsequent edits before restoring. No package cleanup needed.
