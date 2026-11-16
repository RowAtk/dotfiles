# Charcoal Copper Experiment

Base commit: c204656. Branch: experiment/charcoal-copper.
Worktree: /home/rowana/projects/wm-charcoal-copper.
The live home worktree stays on main. Never copy this entire worktree over HOME.

## State

Switchable profiles and Boring mode are now available; see design-switcher.md.
No lock-screen package or automatic locking is part of this experiment.

- Initial palette and Linux keybindings are staged in this worktree only.
- SwayNC trial is installed and running. See swaync-trial.md for additions,
  measurements and rollback. Dunst remains installed; its service is stopped.
- Initial Waybar preview was accepted. Live Hyprland Lua and Kitty configs now
  match the experiment versions; these are deliberate uncommitted changes in
  the home/main worktree, not a merge into main.
- Originals are backed up at:
  /home/rowana/.local/state/wm-charcoal-copper-backup.ayPSPZUm/hyprland.lua
  /home/rowana/.local/state/wm-charcoal-copper-backup.ayPSPZUm/kitty.conf
- Hyprland config-only reload succeeded; subsequent configerrors was empty.
  Live binds confirm no global Command translation and SUPER-arrow focus.
  Kitty received USR1 to reload without closing shells. Applications stayed open.
- To roll back this stage, compare live files against experiment copies first
  to identify subsequent edits, then restore these two backups to their original
  config paths, run hyprctl reload config-only and check hyprctl configerrors.
  Reload Kitty with USR1 again. Restore the original Waybar separately if desired.
- Three-section Waybar preview is active: workspaces/app, clock, media/status.
  Hover the sliders icon to reveal the system drawer. Click media to play/pause;
  right-click media to skip. Clock click toggles date format; calendar is a tooltip.
- Preview startup log: /tmp/waybar-charcoal-copper.log. Startup has no reported
  config/style errors; exactly one live process confirmed after activation.
- Restore normal bar: stop Waybar with pkill -x waybar, then start waybar.
- Existing uncommitted home files, including .zshrc and Vicinae settings, are excluded.

## Package Ledger

Wallpaper palette trial is active; see matugen-trial.md for controls, generated
files, backups, package additions, and rollback.
Synchronized ten-minute rotation is enabled; see rotation-trial.md to pause,
disable, or revert the timer and independent Hyprpaper rotation changes.

packages-before.txt records installed names and versions before experimentation.
Core candidates (currently absent): matugen, swaync, hyprlock.
Screenshot candidates (currently absent): grim, slurp.
Optional, deferred: swayosd, cliphist.
Keep the existing Vicinae launcher and Waybar; no additional shell needed.
Before installation, capture explicit-package and orphan lists as well.
After each transaction, record requested packages, actual new dependencies,
versions, install reason, and transaction date. Record any upgraded existing
packages separately: removing additions does not undo upgrades.

## Activation Plan

1. Confirm the other agent is not editing desktop configs or this dotfiles repo.
2. Back up only the live files being replaced, including current uncommitted content.
3. Install the agreed packages and update this ledger from the actual transaction.
4. Finish and validate palette templates, notification panel, and lock screen.
5. Apply an explicit file allowlist: Hyprland Lua, Waybar, Kitty, plus new theme
   and service configs. Do not overwrite shell or Vicinae settings.
6. Reload without logging out; use live host process visibility to maintain
   exactly one Waybar and one idle daemon. Switch notification daemons deliberately.
7. Check hyprctl configerrors AFTER reload completes, inspect service logs,
   and test clipboard, screenshots, lock/unlock, numeric widths, and resume.
   Test lock manually before enabling automatic locking. Do not close applications.

## End-of-Experiment Cleanup

- Keep: commit only accepted configs; reconcile the package ledger; remove preview
  processes and temporary launch files. Merge only after explicit acceptance.
- Revert: restore backed-up live files only if unchanged since activation;
  preserve or reconcile subsequent edits. Restore previous daemon setup and reload.
- Review only newly installed packages for removal. Keep packages adopted by
  another project; never blindly remove all current orphan packages.
- Review newly introduced dependencies against the before/after package sets
  and install reasons before uninstalling. Do not remove pre-existing packages.
- Remove the experiment worktree only after accepted changes or backups are retained.
- Leave both the other agent's project and unrelated dirty home files untouched.
