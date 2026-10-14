# DECISIONS (ADRs)

## ADR-001: KDE Connect is the control plane
Mature FOSS, protocol v8 security fixes (CVE-2025-66270/32900), covers
notifications/SMS/clipboard/run-commands/media/touchpad/ping/SFTP.
Matches all "remote run + notifications + cross-app" needs.

## ADR-002: No custom protocols
Compose existing tools. Never write new transport/crypto. The unified tool
is a launcher/menu + status + doctor over kdeconnect-cli/localsend/scrcpy/syncthing.

## ADR-003: Four planes
- Control: KDE Connect. Data (large/occasional): LocalSend.
- Pixel (mirror): scrcpy. Background sync: Syncthing + Syncthing-Fork.
- Quick Share native interop (r-quick-share/Packet) is OPTIONAL Phase 08, timeboxed,
  deferrable — LocalSend is the reliable default.

## ADR-004: LAN-only, no cloud
No accounts, no relays. Same-subnet Wi-Fi required. Phone hotspot is the
documented fallback transport. Tailscale/WAN explicitly out of scope for v1.

## ADR-005: iwd deviation (2026-10-14 recon)
Machine uses iwd+systemd-networkd, not NetworkManager. No action for v1 core
stack (KDE Connect/LocalSend/scrcpy/Syncthing are manager-agnostic).
If Phase 08 is attempted, prefer RQuickShare/Packet over pyquickshare
(which expects NetworkManager D-Bus).

## ADR-006: swaync kept
A notification daemon already runs (swaync). Do not install/replace it.
KDE Connect actions surface through it.
