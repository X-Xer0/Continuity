# RUNBOOK — daily usage

## The launcher (most things)
- Keybind: `SUPER SHIFT + P` → ck-menu (or click the phone icon in waybar)
- `SUPER SHIFT + M` → mirror the phone screen

## Menu actions
- Send file(s) to phone → file picker → KDE Connect
- Send clipboard / text to phone → manual share (works even when auto-sync is flaky)
- Mirror phone screen → scrcpy (wireless)
- Ring / Ping / Lock phone
- Send SMS
- Open receive folder (`~/Downloads/continuity`)
- Syncthing dashboard (http://127.0.0.1:8384)
- Run doctor

## Terminal equivalents
```bash
ck-status                 # what's connected
ck-doctor                 # health check
ck-send <file>            # to phone
ck-mirror                 # mirror (requires earlier wireless-adb pairing)
ck-mirror --pair IP:PORT  # first-time wireless pairing (code on phone screen)
ck-mirror --connect IP:PORT
ck-mirror --kill          # stop adb server when done
localsend-cli -f <file>   # TUI: pick the target device by number
```

## Weekly/monthly maintenance
1. `sudo pacman -Syu` + update the 3 Android apps (F-Droid).
2. Run `ck-doctor`.
3. Confirm KDE Connect versions vs SECURITY.md floors.

## After a phone ROM update
- Re-check battery/autostart permissions (android/CHECKLIST.md §3-4).
- Re-check Wireless debugging (port changes are normal).

## Receive folders
- KDE Connect: configured in its settings (set it to `~/Downloads/continuity`)
- LocalSend: `~/Downloads/continuity`
- Syncthing: `~/Sync/continuity`
