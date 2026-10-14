# TEST RESULTS — continuity-kit v0.9.1 (2026-10-14)

Environment: Arch Linux, kernel 7.2.7, Hyprland 0.56.2, Wayland.
kdeconnect 26.08.2 | scrcpy 5.0.1 | android-tools 37.0.0 | syncthing 2.1.6 |
localsend-bin 1.18.2 | LocalSend prefs: quick-save on, dest `~/continuity`.
Phone: Realme 5 Pro, Android 11 / Realme UI 2.0 ("realme 5Pro"), KDE Connect protocol 8.

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
| AT-08 clipboard phone→laptop | PARTIAL [U] | user reported working; definitive re-test pending |
| AT-09 notifications / SMS | PASS [U] | user reported working; `kdeconnect-cli --list-notifications` responds (exit 0) |
| AT-10 run command | PASS [U] | user reported "Phone says hi" flow working; allowlist = exactly 2 safe commands |
| AT-11 screen mirror | BLOCKED [M] | `adb connect 192.0.2.25:42067` → "Connection refused" (port rotated); needs fresh pairing-dialog values |
| AT-12 Syncthing | PAUSED (by user request) | see note below |
| AT-13 doctor | PASS [M] | `ck-doctor` → 9 ok, 0 warn, 0 fail, exit 0 |
| AT-14 reboot persistence | PENDING | to run after AT-11/12 close |
| RESTORE | PASS [M] | `--restore 20261014-164909` reverted hyprland.conf + waybar config; `--apply` re-integrated; waybar alive, doctor 9/9 |
| FOLDER MIGRATION | PASS [M] | receive folder moved `~/Downloads/continuity` → `~/continuity`; kdeconnect `incoming_path` and LocalSend destination updated + verified live |

## AT-12 note (why paused)
The phone accepted the Syncthing folder offer but pointed it at its **entire internal
storage root**. The laptop began pulling the phone's whole shared storage:
6,046 files / ~6.9 GB global, 6,046 pull errors, ~75 MB already downloaded into
`~/Sync/continuity`. The folder was **paused on the laptop** (reversible, nothing deleted)
to stop the transfer. Recommended later fix: remove the folder pair on both sides,
recreate with a dedicated path (laptop `~/Sync/continuity` ⇄ phone `Sync/continuity`),
then resume. User said "leave Syncthing for now" — deferred by choice.

## Remaining before v1.0.0 tag
1. AT-11: fresh pairing dialog values (pairing port + 6-digit code + connect port) →
   `ck-mirror --pair` + `--connect` + mirror test.
2. AT-12: recreate syncthing folder with dedicated path (deferred by user).
3. AT-08 definitive clipboard re-test (copy on phone → `wl-paste`).
4. AT-14 reboot spot-check.
