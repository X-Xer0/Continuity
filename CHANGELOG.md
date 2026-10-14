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
