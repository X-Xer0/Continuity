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

## Preflight 2026-10-14T16:51:09+05:30
```
== continuity-kit preflight 2026-10-14T16:51:08+05:30 ==

== system ==

$ uname -r
7.2.9-arch1-1

$ grep -E ^(ID|PRETTY_NAME)= /etc/os-release
PRETTY_NAME="Arch Linux"
ID=arch
session=wayland desktop=Hyprland

== compositor ==

$ hyprctl version
Hyprland 0.56.2 built from branch v0.56.2 at commit efb50993780079460b0cbed1363e2166a2de1d9f clean ([gha] Nix: update inputs).
Date: Wed Aug 5 14:13:21 2026
Tag: v0.56.2, commits: 7661

Libraries:
Hyprgraphics: built against 0.5.1, system has 0.5.1
Hyprutils: built against 0.14.2, system has 0.14.2
Hyprcursor: built against 0.1.13, system has 0.1.13
Hyprlang: built against 0.6.8, system has 0.6.8
Aquamarine: built against 0.15.1, system has 0.15.1

Version ABI string: efb50993780079460b0cbed1363e2166a2de1d9f_aq_0.15_hu_0.14_hg_0.5_hc_0.1_hlg_0.6
no flags were set


$ hyprctl configerrors



== packages ==
kdeconnect 26.08.2-1
scrcpy 5.0.1-1
android-tools 37.0.0-5
syncthing 2.1.6-1
wl-clipboard 1:2.3.0-1
cliphist 1:0.7.0-2
wl-clip-persist 0.5.0-2
zenity 4.2.2-1
sshfs 3.7.6-1
bluez 5.87-2
bluez-utils 5.87-2
pipewire 1:1.6.9-1
wireplumber 0.5.18-1
xdg-desktop-portal-hyprland 1.4.1-2
xdg-desktop-portal-gtk 1.15.3-1
libei 1.6.0-1
shellcheck 0.11.0-156

== user services ==
xdg-desktop-portal               active
xdg-desktop-portal-hyprland      active
syncthing.service                active

== system services ==
bluetooth                        active
iwd                              active
systemd-networkd                 active
NetworkManager                   inactive

== processes ==
kdeconnectd: running
swaync: running
mako: not running
dunst: not running
waybar: running
Hyprland: running

== network ==

$ ip -brief -4 addr
lo               UNKNOWN        127.0.0.1/8 
enp0s20f0u2      UNKNOWN        10.247.132.236/24 metric 100 

== tools ==
yay              present
paru             absent
nft              present
ufw              absent
firewall-cmd     absent
adb              present
scrcpy           present
syncthing        present
kdeconnect-cli   present
wl-copy          present
wofi             absent
rofi             present
localsend        present
localsend-cli    present

== privileges ==
non-interactive sudo: needs password (HUMAN STEP for installs)

== end ==
```
