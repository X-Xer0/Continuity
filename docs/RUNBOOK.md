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
- Open receive folder (`~/continuity`)
- Syncthing dashboard (http://127.0.0.1:8384)
- Run doctor

## Terminal equivalents
```bash
ck-status                 # what's connected
ck-doctor                 # health check
ck-send <file>            # to phone
ck-mirror                 # mirror the phone (auto-picks device; wireless preferred)
ck-mirror --setup-usb     # after a phone reboot: plug USB once, restores fixed wireless port 5555
ck-mirror --doctor        # show adb state
ck-mirror --kill          # stop adb server when done (hygiene)
localsend-cli -f <file>   # TUI: pick the target device by number
```

## Screen mirroring notes
- The phone is set to a **fixed wireless adb port (5555)** so no pairing/port dance is needed.
- After the phone **reboots** the fixed port is gone once: plug the USB cable, run
  `ck-mirror --setup-usb`, unplug. (USB debugging must stay enabled on the phone.)
- If USB is unavailable, the fallback is Wireless debugging → read the port → `ck-mirror --connect IP:PORT`.
- `ck-mirror --kill` stops the local adb server when you are done (recommended on untrusted networks).

## Weekly/monthly maintenance
1. `sudo pacman -Syu` + update the 3 Android apps (F-Droid).
2. Run `ck-doctor`.
3. Confirm KDE Connect versions vs SECURITY.md floors.

## After a phone ROM update
- Re-check battery/autostart permissions (android/CHECKLIST.md §3-4).
- Re-check Wireless debugging (port changes are normal).

## Receive folders
- KDE Connect: configured in its settings (set it to `~/continuity`)
- LocalSend: `~/continuity`
- Syncthing: `~/Sync/continuity`
