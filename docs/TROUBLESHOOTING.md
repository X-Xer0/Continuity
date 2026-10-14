# TROUBLESHOOTING — known issues + fixes

## General first moves
1. `ck-doctor` — shows which layer is broken.
2. `kdeconnect-cli --refresh && kdeconnect-cli -l --id-name-only`
3. Same SSID on both devices? (check `ip -brief -4 addr`)
4. Re-run `install/00-preflight.sh`.

## KDE Connect
- **Not appearing in device list**: same network? `kdeconnectd` running (`pgrep -x kdeconnectd`)?
  UDP 1716 broadcast blocked? Try `kdeconnect-cli --refresh`. Check firewall rules
  (`install/20-firewall.sh`). Guest Wi-Fi with client isolation breaks this — use phone hotspot.
- **Disconnects after ~30 s**: phone killed the app. Re-apply android/CHECKLIST.md §3 (battery + autostart + recents lock).
- **Clipboard sync not working (Wayland limitation, known)**:
  KDE Connect clipboard relies on focus/portal behavior on Wayland (KDE bug 410162).
  Mitigations already installed: `wl-clip-persist` + `cliphist` (watchers in Startup_Apps.conf).
  If it still won't sync: use ck-menu → "Send clipboard to phone" / "Send text to phone" manually.
  Do not spend more than 30 min on this; it is a documented upstream limitation.
- **Remote input (touchpad/keyboard) not working**: needs a RemoteDesktop portal backend.
  Hyprland's portal may or may not implement it. If broken, the approved fallback is
  `wayland-kdeconnect-fix` (third-party; requires explicit user approval — see SECURITY.md).
- **Ring/ping does nothing**: on Realme UI the app must be unlocked/foreground at least once;
  check battery/autostart again.

## LocalSend
- **Devices not discovering each other**: port 53317 TCP+UDP must be open locally;
  same subnet check; AP isolation breaks discovery → hotspot fallback.
- **CLI note**: `localsend-cli` is an interactive TUI. Usage: `localsend-cli -f <file>` then
  press the number of the target device. It is NOT `localsend-cli send ...`.

## scrcpy / ADB
- **`unauthorized` / `offline`**: phone must be unlocked when pairing/connecting;
  retry `ck-mirror --pair`, confirm the RSA dialog on the phone.
- **Port changes after reboot**: Android 11 wireless debugging picks a random port.
  Re-run `ck-mirror --pair` (new code) then `ck-mirror --connect`.
- **`adb: no devices`**: enable Wireless debugging, same network as laptop.
- **Only USB available**: enable USB debugging, plug in, `adb tcpip 5555`,
  then `ck-mirror --connect <phone-ip>:5555` (documented fallback).
- Hygiene: `ck-mirror --kill` (stops adb server) when done.

## Syncthing
- **Phone shows "0/0" or won't sync**: battery/autostart settings again (both ends);
  check `systemctl --user status syncthing` on laptop.
- **Device not connecting**: both must have each other added; check the other side's
  "Pending devices" and accept.
- **Default folder**: laptop `~/Sync/continuity`; phone `Sync/continuity` under internal storage.

## Waybar
- **Module shows a box glyph**: the nerd-font glyph may be missing. Run
  `CK_ICON=PH ck-status --waybar` to test a text fallback, then set the icon in
  `~/.config/waybar/continuity.jsonc` (env or edit).
- **Module missing after update**: re-run `install/30-apply-config.sh --apply` and
  `killall -SIGUSR2 waybar`.

## Quick Share native interop (Phase 08)
- **Deferred by design (optional).** Try only if native Android Sharesheet integration
  is really wanted. Requires: AUR `r-quick-share` (needs sudo to install), BlueZ dual
  mode (already default), avahi. Timebox 45 min; if discovery fails twice, keep LocalSend.
- Note: this laptop runs iwd + systemd-networkd, NOT NetworkManager — so avoid
  `pyquickshare` (expects NetworkManager D-Bus).
