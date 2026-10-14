# ACCEPTANCE TESTS — run with the user present, record in TEST_RESULTS.md

| ID | Test | Exact steps | Pass criteria |
|---|---|---|---|
| AT-01 | Pairing | `kdeconnect-cli -l --id-name-only` and `kdeconnect-cli --encryption-info` | Phone listed; protocol version 8 |
| AT-02 | Ping | `kdeconnect-cli -d <ID> --ping` | Phone vibrates / shows ping |
| AT-03 | Ring | `kdeconnect-cli -d <ID> --ring` | Phone rings |
| AT-04 | Send file | `ck-send <file>` | File appears in phone's KDE Connect downloads |
| AT-05 | Receive file | Share a file from phone's Sharesheet → KDE Connect | File lands in configured laptop folder |
| AT-06 | LocalSend | 100 MB file both directions | Delivered; sha256 match both sides |
| AT-07 | Clipboard → phone | Copy text on laptop; ck-menu → "Send clipboard to phone" | Text pastes on phone |
| AT-08 | Clipboard → laptop | Copy text on phone | `wl-paste` shows it on laptop (Linux-side sync may need focus) |
| AT-09 | Notification + SMS | Trigger phone notification; reply to an SMS from laptop (`kdeconnect-sms` or the indicator) | Notification visible in swaync; reply delivered |
| AT-10 | Run command | KDE Connect app → Run command → "Phone says hi" | Laptop notification appears; nothing else runs |
| AT-11 | Mirror | `ck-mirror` (wireless adb set up) | Window appears; mouse+keyboard control works; close; `ck-mirror --kill` |
| AT-12 | Syncthing | Create file in `~/Sync/continuity`; then delete it after sync | Syncs both ways ≤60 s; hashes match; deletion propagates |
| AT-13 | Doctor | `ck-doctor` | exit 0 (warnings allowed) |
| AT-14 | Reboot persistence | Reboot; run AT-01 + AT-02 + AT-12 | All pass without manual steps |

Notes:
- AT-08 is subject to the documented Wayland clipboard limitation; if it fails, record as
  limitation and verify via ck-menu → "Send clipboard to phone" in the other direction.
- AT-11 requires the phone's Wireless debugging screen for first pairing.
