# TEST RESULTS — continuity-kit v0.9 (2026-10-14)

Environment: Arch Linux, kernel 7.2.7, Hyprland 0.56.2, Wayland.
kdeconnect 26.08.2 | scrcpy 5.0.1 | android-tools 37.0.0 | syncthing 2.1.6 |
localsend-bin 1.18.2 | LocalSend prefs: quick-save on, dest ~/Downloads/continuity.
Phone: Realme 5 Pro, Android 11 / Realme UI 2.0 ("realme 5Pro", KDE Connect protocol 8).

Legend: [M] machine-verified with pasted output · [U] user-confirmed on-device · [ ] pending

| ID | Result | Evidence |
|---|---|---|
| AT-01 pairing | PASS [M] | `kdeconnect-cli -l` → "realme 5Pro ... paired and reachable"; `--encryption-info` → Protocol version: 8 |
| AT-02 ping | PASS [M] | `kdeconnect-cli -d <id> --ping` issued, exit 0 |
| AT-03 ring | PASS [M] | `kdeconnect-cli -d <id> --ring` issued, exit 0 |
| AT-04 laptop→phone file | PASS [M] | `--share /tmp/continuity-test.txt` → "Shared file:///tmp/continuity-test.txt" |
| AT-05 phone→laptop file | PASS [M] | `~/Downloads/continuity/`: `continuity-test.txt` (51 B) + `Screenshot_...jpg` (542 KB) received from phone |
| AT-06 LocalSend | PARTIAL [M+U] | small-file transfers confirmed (files above arrived); 100 MB stress test not run |
| AT-07 clipboard laptop→phone | PASS [U] | user reported working; command path: ck-menu → "Send clipboard to phone" |
| AT-08 clipboard phone→laptop | PARTIAL [U] | user reported working; definitive re-test requested (copy text on phone → `wl-paste`) |
| AT-09 notifications / SMS | PASS [U] | user reported working; `kdeconnect-cli --list-notifications` responds (exit 0, list empty at test time) |
| AT-10 run command | PASS [U] | user reported "Phone says hi" flow working; allowlist deployed with exactly 2 safe commands |
| AT-11 screen mirror | PENDING | wireless-debug pairing not completed (see TROUBLESHOOTING: fresh pairing code + port required) |
| AT-12 Syncthing | PENDING | folder `continuity` shared; phone completion 0 %, `remoteState: unknown`, `needItems: 1` → phone has not accepted the folder offer yet |
| AT-13 doctor | PASS [M] | `ck-doctor` → 9 ok, 0 warn, 0 fail, exit 0 |
| AT-14 reboot persistence | PENDING | to run after AT-11/AT-12 close |
| RESTORE | PASS [M] | `--restore 20261014-164909` reverted hyprland.conf + waybar config (continuity refs = 0); `--apply` re-integrated (refs = 1/2); waybar alive, `hyprctl configerrors` empty, doctor 9/9 |

## Notes
- Syncthing: laptop folder idle, 1 local file (`hello.txt`), 0 need on our side; the ball is
  on the phone (accept the offered folder, path recommended: internal storage `Sync/continuity`).
- adb wireless: two user errors explained — (a) "protocol fault (couldn't read status message):
  Success" = stale/incorrect pairing port or the pairing dialog was closed; (b) "bad port number
  'DEBUG-PORT'" = placeholder text left literally in the command.
- `ck-doctor` after rollback+re-apply stayed green; rollback path is proven.

## Remaining before v1.0.0 tag
1. AT-12: phone accepts Syncthing folder; verify completion 100 % + file content.
2. AT-11: complete adb pairing; verify mirror window + control; `ck-mirror --kill` after.
3. AT-08: one definitive clipboard re-test.
4. AT-14: reboot; spot-check AT-01/02/12.
