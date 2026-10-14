# continuity-kit

Wireless phone↔laptop integration for Arch Linux + Hyprland (Dell) + Realme 5 Pro (Android 11).

Apple/Google/Samsung-style continuity built by composing existing FOSS tools — no custom protocols.

## Stack (4 planes)

| Plane | Tool | Purpose |
|---|---|---|
| Control | KDE Connect | notifications, clipboard, SMS, run commands, media, touchpad, ping, SFTP |
| Data | LocalSend | fast large file/message transfer both directions |
| Pixel | scrcpy | wireless phone screen mirror + control over ADB |
| Sync | Syncthing (+Fork on phone) | continuous background folder sync |

LAN-only. No cloud accounts. No rooting/flashing.

## Quickstart (after full setup)

```bash
~/.local/bin/ck-doctor          # health check, exit 0 = healthy
~/.local/bin/ck-menu            # wofi menu: send, mirror, ring, SMS, folders
~/.local/bin/ck-send <file>     # send file to phone via KDE Connect
~/.local/bin/ck-mirror          # mirror phone screen (wireless ADB)
```

## Repo layout

See execution plan + `docs/RUNBOOK.md` (written in Phase 11).
`install/apply-config.sh` is the ONLY writer of home configs; it backs up first and
supports `--dry-run` (default), `--apply`, `--restore`.

## Status

Phase 00 in progress. See `docs/RECON.md`, `docs/DECISIONS.md`.
