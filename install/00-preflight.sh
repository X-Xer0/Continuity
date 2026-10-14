#!/usr/bin/env bash
# 00-preflight.sh — read-only environment recon for continuity-kit.
# Usage:
#   ./install/00-preflight.sh           # print report + write log
#   ./install/00-preflight.sh --write   # also append a dated block to docs/RECON.md
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/continuity-kit"
mkdir -p "$STATE/logs"
LOG="$STATE/logs/preflight-$(date +%Y%m%d-%H%M%S).log"
WRITE=0
[[ "${1:-}" == "--write" ]] && WRITE=1

run() { printf '\n$ %s\n' "$*"; "$@" 2>&1 || printf '(exit %d)\n' "$?"; }
have() { command -v "$1" >/dev/null 2>&1 && echo present || echo absent; }
pkg() { pacman -Q "$@" 2>&1 || true; }

{
  echo "== continuity-kit preflight $(date -Is) =="

  echo
  echo "== system =="
  run uname -r
  run grep -E '^(ID|PRETTY_NAME)=' /etc/os-release
  printf 'session=%s desktop=%s\n' "${XDG_SESSION_TYPE:-unset}" "${XDG_CURRENT_DESKTOP:-unset}"

  echo
  echo "== compositor =="
  run hyprctl version
  run hyprctl configerrors

  echo
  echo "== packages =="
  pkg kdeconnect scrcpy android-tools syncthing wl-clipboard cliphist wl-clip-persist \
      zenity sshfs bluez bluez-utils pipewire wireplumber \
      xdg-desktop-portal-hyprland xdg-desktop-portal-gtk libei shellcheck

  echo
  echo "== user services =="
  for u in xdg-desktop-portal xdg-desktop-portal-hyprland syncthing.service; do
    printf '%-32s %s\n' "$u" "$(systemctl --user is-active "$u" 2>/dev/null || true)"
  done

  echo
  echo "== system services =="
  for s in bluetooth iwd systemd-networkd NetworkManager; do
    printf '%-32s %s\n' "$s" "$(systemctl is-active "$s" 2>/dev/null || true)"
  done

  echo
  echo "== processes =="
  for p in kdeconnectd swaync mako dunst waybar; do
    if pgrep -x "$p" >/dev/null 2>&1; then echo "$p: running"; else echo "$p: not running"; fi
  done
  if pgrep -x Hyprland >/dev/null 2>&1 || pgrep -x hyprland >/dev/null 2>&1; then
    echo "Hyprland: running"
  else
    echo "Hyprland: not running"
  fi

  echo
  echo "== network =="
  run ip -brief -4 addr

  echo
  echo "== tools =="
  for t in yay paru nft ufw firewall-cmd adb scrcpy syncthing kdeconnect-cli wl-copy wofi rofi localsend localsend-cli; do
    printf '%-16s %s\n' "$t" "$(have "$t")"
  done

  echo
  echo "== privileges =="
  if sudo -n true 2>/dev/null; then
    echo "non-interactive sudo: OK"
  else
    echo "non-interactive sudo: needs password (HUMAN STEP for installs)"
  fi

  echo
  echo "== end =="
} | tee "$LOG"

if [[ "$WRITE" -eq 1 ]]; then
  {
    echo
    echo "## Preflight $(date -Is)"
    echo '```'
    cat "$LOG"
    echo '```'
  } >> "$REPO/docs/RECON.md"
  echo "appended to docs/RECON.md"
fi
echo "log: $LOG"
