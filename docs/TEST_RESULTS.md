# TEST RESULTS — continuity-kit v0.9.2 (updated 2026-10-22)

Environment: Arch Linux, kernel 7.2.7, Hyprland 0.56.2, Wayland.
kdeconnect 26.08.2 | scrcpy 5.0.1 | android-tools 37.0.0 | localsend-bin 1.18.2 |
LocalSend prefs: quick-save `on`, dest `~/continuity`.
Phone: Realme 5 Pro, Android 11 / Realme UI 2.0 ("realme 5Pro"), KDE Connect protocol 8.
Syncthing support: **removed 2026-10-22** at user request (phone app uninstalled).

Legend: [M] machine-verified with pasted output · [U] user-confirmed on-device · [ ] pending

| ID | Result | Evidence |
|---|---|---|
| AT-01 pairing | PASS [M] | `kdeconnect-cli -l` → "realme 5Pro ... paired and reachable"; `--encryption-info` → Protocol version: 8 |
| AT-02 ping | PASS [M] | `kdeconnect-cli -d <id> --ping` issued, exit 0 |
| AT-03 ring | PASS [M] | `kdeconnect-cli -d <id> --ring` issued, exit 0 |
| AT-04 laptop→phone file | PASS [M] | `--share /tmp/continuity-test.txt` → "Shared file:///tmp/continuity-test.txt" |
| AT-05 phone→laptop file | PASS [M] | `~/continuity/`: `continuity-test.txt` (51 B) + `Screenshot_...jpg` (542 KB) received from phone |
| AT-06 LocalSend | PARTIAL [M+U] | small-file transfers confirmed; 100 MB stress test not run |
| AT-07 clipboard laptop→phone | PASS [U] | user reported working (ck-menu → "Send clipboard to phone") |
| AT-08 clipboard phone→laptop | PASS [U] | user confirmed after full workflow |
| AT-09 notifications / SMS | PASS [U] | user reported working; `kdeconnect-cli --list-notifications` responds (exit 0) |
| AT-10 run command | PASS [U] | user reported "Phone says hi" flow working; allowlist = exactly 2 safe commands |
| AT-11 screen mirror (Wi-Fi) | PASS [M+U] | wireless `adb connect` → scrcpy window "RMX1971" mapped (class=scrcpy); user confirmed working |
| AT-11b screen mirror (USB) | PASS [M+U] | `ck-mirror --usb` → `scrcpy -s <usb-serial>`; window mapped; switched live from Wi-Fi session; user confirmed |
| AT-12 Syncthing | REMOVED | feature dropped 2026-10-22 at user request (phone app uninstalled); scripts/docs/tests updated |
| AT-13 doctor | PASS [M] | `ck-doctor` → 9 ok, 0 warn, 0 fail, exit 0 |
| AT-14 reboot persistence | PENDING | to run after next reboot |
| RESTORE | PASS [M] | `--restore <backup>` reverted hyprland.conf + waybar config; `--apply` re-integrated; waybar alive, doctor green |
| FOLDER MIGRATION | PASS [M] | receive folder moved `~/Downloads/continuity` → `~/continuity`; kdeconnect `incoming_path` and LocalSend destination updated + verified live |
| ADB FIXED PORT | PASS [M] | USB → `tcpip 5555` → wireless `192.0.2.25:5555 device`; `ck-mirror --setup-usb` added for post-reboot recovery; direct wireless-debug pairing also proven |
| LOCALSEND AUTOSTART | FIXED [M] | startup crash "type 'bool' is not a subtype of type 'String?'" caused by `ls_quick_save` written as bool; now written as QuickSaveMode string `"on"`; live prefs repaired, LocalSend starts clean (0 type-cast errors) |

## AT-12 removal note
Syncthing was dropped on 2026-10-22 because the phone app was uninstalled (judged not useful).
The laptop service was disabled; `~/Sync/continuity` content and the syncthing package were
left untouched (no data deleted). The stack is now three planes: control (KDE Connect),
data (LocalSend), pixel (scrcpy).

## Remaining before v1.0.0 tag
1. AT-14 reboot spot-check (mirror recovery after reboot = `ck-mirror --setup-usb`)
