# Changelog

## [Unreleased]

### Added — 2026-10-14
- Phase 00: repo scaffold, live recon report (`docs/RECON.md`), ADRs, discrepancies log
- Phase 01: idempotent package installer + preflight script; package set verified
  (kdeconnect 26.08.2, scrcpy 5.0.1, android-tools 37, syncthing 2.1.6, localsend 1.18.2)
- Phase 02: Hyprland UserConfigs integration (`02-Continuity.conf` + source line),
  waybar module + include wiring, safe `--apply/--restore` config writer,
  wl-clip-persist running; kdeconnectd running
- Phase 03: firewall helper + nftables template (no active firewall on this machine)
- Phase 09: `ck-menu`, `ck-status`, `ck-doctor`, `ck-send`, `ck-mirror` live in `~/.local/bin`
- Phase 11 (partial): safe uninstall helper, security/runbook/capability/troubleshooting docs
- Syncthing user service enabled and active; device ID available via `syncthing device-id`

### Verified live — 2026-10-14 (phone steps done)
- KDE Connect paired with "realme 5Pro"; protocol version 8 (AT-01)
- ping, ring, and a test file share to the phone executed (AT-02/03/04)
- Runcommand allowlist deployed (2 safe commands); share incoming_path -> `~/continuity`
- LocalSend: quick_save on, destination `~/continuity`, tray-minimize, `--hidden` autostart

### Changed — 2026-10-14 (evening)
- Receive folder migrated `~/Downloads/continuity` -> `~/continuity` (per user request);
  kdeconnect `incoming_path`, LocalSend destination, ck-menu, docs updated and verified live
- Test results recorded in `docs/TEST_RESULTS.md`; rollback (`--restore`) + re-apply proven
- Syncthing folder PAUSED on laptop: phone side pointed the share at its entire internal
  storage (6,046 files / ~6.9 GB, 6,046 pull errors). Transfer stopped, nothing deleted.
  Fix deferred by user: recreate folder pair with dedicated `Sync/continuity` path
- AT-11 blocked: stale wireless-debug port (rotates); requires fresh pairing-dialog values
- Mirror pipeline completed: USB → `adb tcpip 5555` → wireless mirror running; `ck-mirror`
  now prefers the wireless device and gained `--setup-usb` for post-reboot recovery

