# ARCHITECTURE — three planes, all LAN-only

```
                    ┌────────────────────────────┐
                    │        Realme 5 Pro        │
                    │  KDE Connect / LocalSend / │
                    │  adb                       │
                    └───────┬────────┬───────────┘
                            │  Wi-Fi LAN (or phone hotspot / USB tether)
   ┌────────────────────────┴────────┴──────────────────────────┐
   │                        laptop (Arch + Hyprland)            │
   │                                                            │
   │  CONTROL  kdeconnectd  ──► swaync notifications, SMS,      │
   │            (TCP 1714-1764 / UDP 1716)  clipboard, commands │
   │                                                            │
   │  DATA     localsend(-cli) (TCP/UDP 53317)  big files       │
   │                                                            │
   │  PIXEL    adb + scrcpy  (USB or wireless debugging)        │
   │                                                            │
   │  UX       ck-menu (rofi/wofi) · ck-status (waybar) ·       │
   │           ck-doctor · ck-send · ck-mirror                  │
   └────────────────────────────────────────────────────────────┘
```

## Design rules
- Compose existing tools; no custom protocols or crypto (ADR-002).
- All three planes are independent: if one breaks, the others keep working.
- The only writer of home configs is `install/30-apply-config.sh` (backup + restore).
- Phone side is stock Android 11, no root, no custom ROM (ADR-001 scope).
- Syncthing support was removed on 2026-10-22 (ADR-009).

## Repo map
- `install/` idempotent setup scripts (preflight, packages, firewall, apply, uninstall)
- `bin/` user-facing tools symlinked into `~/.local/bin`
- `configs/` integration snippets for hyprland, waybar, firewalls
- `docs/` runbook, security, tests, troubleshooting, decisions
- `android/CHECKLIST.md` the phone-side steps (human required)
