# DISCREPANCIES — plan vs reality (found during execution)

1. **NetworkManager assumed, iwd + systemd-networkd actually in use** (2026-10-14).
   Core stack unaffected. Action: avoid pyquickshare (needs NetworkManager). See ADR-005.
2. **`localsend-cli` interface is an interactive TUI**, not a `send` subcommand.
   Correct usage: `localsend-cli -f <file>` then press the device number. Docs updated.
3. **wofi not installed; rofi is** — ck-menu already falls back to rofi. No action.
4. **Hyprland process name is `Hyprland` (capitalized)** — preflight pgrep fixed.
5. **No active firewall manager** (no ufw/firewalld service); nft binary present.
   nftables template shipped for manual review only. No rules applied.
6. **Laptop currently has no wlan0 address; a USB interface is active**
   (`enp0s20f0u2`, 10.247.132.x) — possibly USB tethering. Pairing instructions
   accept any shared LAN (Wi-Fi / tether / hotspot).
