# RECON — 2026-10-14 (Phase 00, live outputs)

## Kernel / OS
- `uname -r` → `7.2.7-arch1-1`
- `/etc/os-release` → `Arch Linux`, `ID=arch`
- Interpretation: current Arch, recent kernel.

## Session / compositor
- `XDG_SESSION_TYPE=wayland`, `XDG_CURRENT_DESKTOP=Hyprland`
- `hyprctl version` → Hyprland 0.56.2 (Aug 2026 build)
- Portals: `xdg-desktop-portal-hyprland` active, `xdg-desktop-portal` active
- `hyprctl configerrors` → empty (clean)
- `hyprctl binds | SUPER+SHIFT+P` → free (keybind available)

## Packages present
- hyprland 0.56.2-3, xdg-desktop-portal-hyprland 1.4.1-2 → OK
- wl-clipboard 2.3.0-1, cliphist 0.7.0-2, xdg-desktop-portal-gtk 1.15.3-1,
  libei 1.6.0-1, bluez 5.87-2, bluez-utils 5.87-2,
  pipewire 1.6.9-1, wireplumber 0.5.17-2 → OK
- swaync running (PID 850) → notification daemon present, keep it

## Packages MISSING (to install in Phase 01)
- kdeconnect, scrcpy, android-tools, syncthing
- wl-clip-persist, zenity, sshfs
- AUR: localsend-bin, localsend-cli-bin, r-quick-share, valent → all absent

## Network (important deviation from plan assumption)
- Wi-Fi chip: Qualcomm Atheros QCA9377 (Dell DW1810), ath10k_pci → Wi-Fi 5 (802.11ac), no Wi-Fi 6
- `ip -brief -4 addr` → wlan0 UP, 192.0.2.219/24 + 192.0.2.220/24 (same subnet, DHCP)
- Network management: **iwd active + systemd-networkd active, NetworkManager INACTIVE**
  → Plan assumed NetworkManager (needed by pyquickshare). Consequence: prefer
  RQuickShare/Packet if Quick Share interop is ever attempted; document in TROUBLESHOOTING.
- `lsusb` unavailable (usbutils not installed) → BT USB topology unverified;
  `bluetoothctl 5.87` present, `bluetooth` service active.

## Firewall
- ufw inactive/absent, firewalld inactive/absent, `nft` binary present
- No active firewall → Phase 03 will write an nftables drop-in for manual review,
  NOT touch live ruleset.

## Privileges / tooling
- `sudo -n true` → password required → installs need HUMAN STEP (user runs block)
- AUR helper: `yay` at /usr/bin/yay → OK

## Phone (pending HUMAN STEP)
- Realme 5 Pro, stock Android 11 / Realme UI 2.0 assumed; apps not yet installed.
- Same-SSID check + pairing deferred to Phase 04.
