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

See execution plan + `docs/RUNBOOK.md`.
`install/30-apply-config.sh` is the ONLY writer of home configs; it backs up first and
supports `--dry-run` (default), `--apply`, `--restore`.

## Status (2026-10-14)

- Phases done: 00 (scaffold/recon), 01 (packages verified), 02 (hypr/waybar/clipboard
  integration applied), 03 (no active firewall; template shipped), 09 (ck-* tooling live)
- Pending (needs the phone): 04 pairing, 05 LocalSend, 06 scrcpy wireless,
  07 Syncthing pairing, 10 acceptance tests, 11 hardening sign-off
- 08 (Quick Share interop): optional/deferred
- Details: `docs/CAPABILITY_MATRIX.md`, `docs/TEST_RESULTS.md` (once tests run)

### LocalSend CLI note
`localsend-cli` is an interactive TUI: `localsend-cli -f <file>` then pick the device
number. It is not a `send` subcommand.

