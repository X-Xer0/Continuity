# continuity-kit

Wireless phone↔laptop integration for Arch Linux + Hyprland (Dell) + Realme 5 Pro (Android 11).

Apple/Google/Samsung-style continuity built by composing existing FOSS tools — no custom protocols.

## Stack (4 planes)

| Plane | Tool | Purpose |
|---|---|---|
| Control | KDE Connect | notifications, clipboard, SMS, run commands, media, touchpad, ping, SFTP |
| Data | LocalSend | fast large file/message transfer both directions |
| Pixel | scrcpy | phone screen mirror + control over ADB (USB preferred, Wi-Fi fixed port 5555) |
| Sync | Syncthing (+Fork on phone) | continuous background folder sync |

LAN-only. No cloud accounts. No rooting/flashing.

## Quickstart (after full setup)

```bash
~/.local/bin/ck-doctor           # health check, exit 0 = healthy
~/.local/bin/ck-menu             # launcher menu: send, mirror, ring, SMS, folders
~/.local/bin/ck-send <file>      # send file to phone via KDE Connect
~/.local/bin/ck-mirror           # mirror phone screen (USB if attached, else Wi-Fi)
~/.local/bin/ck-mirror --usb     # force USB transport
~/.local/bin/ck-mirror --setup-usb  # after phone reboot: restore fixed wireless port
```

## Repo layout

See execution plan + `docs/RUNBOOK.md`.
`install/30-apply-config.sh` is the ONLY writer of home configs; it backs up first and
supports `--dry-run` (default), `--apply`, `--restore`.

## Status (2026-10-14, v0.9.1)

- **Working + verified**: KDE Connect control plane (notifications, SMS, clipboard,
  run-commands, ping/ring/lock), file share both ways, LocalSend, scrcpy mirroring
  (USB preferred; Wi-Fi fixed port 5555 with `--setup-usb` recovery), receive folder
  `~/continuity`, doctor 9/9 green, rollback (`--restore`) proven.
- **Open items**: Syncthing folder redo (deferred by user — phone shared whole storage),
  reboot spot-check, then `v1.0.0`.
- 08 (Quick Share interop): optional/deferred.
- Details: `docs/TEST_RESULTS.md`, `docs/CAPABILITY_MATRIX.md`, `docs/RUNBOOK.md`.

### LocalSend CLI note
`localsend-cli` is an interactive TUI: `localsend-cli -f <file>` then pick the device
number. It is not a `send` subcommand.

