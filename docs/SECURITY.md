# SECURITY — continuity-kit

Threat model: trusted home LAN. Nothing here is safe on hostile networks.

## Version floors (CVE-driven)
- KDE Connect desktop ≥ 25.12 (CVE-2025-66270 auth bypass, CVE-2025-32900 spoofing).
  This machine: 26.08.2 ✔
- KDE Connect Android ≥ 1.34.4 (same fixes). Verify on phone.
- Keep KDE Connect, LocalSend, scrcpy, syncthing updated (monthly `pacman -Syu`).

## Rules enforced by this repo
- LAN-only designs; no cloud accounts or relays.
- Pairing only on trusted networks; phone "Trusted Networks" set to home SSID.
- Runcommand allowlist is implemented in `configs/kdeconnect/runcommand-config` and deployed
  by `install/30-apply-config.sh` (step 4): exactly two non-destructive commands
  (`notify-send`, `hyprctl notify`). No suspend/reboot/rm/sudo commands.
- Incoming file shares land in `~/continuity` (kdeconnect_share `incoming_path`).
- LocalSend: Quick Save on + destination `~/continuity` + PIN on phone.
- No secrets in the repo: no device IDs, ADB keys, IPs, SMS content. `.gitignore` covers logs/backups.
- ADB hygiene: `ck-mirror --kill` after mirroring; Wireless debugging off when idle;
  never expose port 5555 beyond the LAN.
- Backups: `install/30-apply-config.sh --restore` tested once before declaring v1.0.

## Trusted components
Installed from official repos / AUR: kdeconnect, scrcpy, android-tools, syncthing,
wl-clipboard/persist, cliphist, zenity, sshfs, localsend-bin, localsend-cli-bin.

## Fallback component requiring explicit approval
- `wayland-kdeconnect-fix` (GitHub: iamnarayana/wayland-kdeconnect-fix): third-party,
  partially AI-written portal bridge for KDE Connect remote input on Hyprland.
  Install ONLY if remote input is broken, and only after user approval; audit the source first.

## Not installed by design
- OpenDrop/OWL (AirDrop interop), pyquickshare (needs NetworkManager), any cloud relay.
- Quick Share interop (r-quick-share): optional, deferred; needs sudo to install.
