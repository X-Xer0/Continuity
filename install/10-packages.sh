#!/usr/bin/env bash
# 10-packages.sh — idempotent package installer for continuity-kit.
# Usage:
#   ./install/10-packages.sh          # dry-run: report what is missing
#   ./install/10-packages.sh --yes    # install missing packages (prompts for sudo)
set -euo pipefail

BASE_PKGS=(
  kdeconnect scrcpy android-tools syncthing
  wl-clipboard wl-clip-persist cliphist
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
  libei bluez bluez-utils pipewire wireplumber
  zenity sshfs usbutils shellcheck
)
AUR_PKGS=(localsend-bin localsend-cli-bin)

YES=0
[[ "${1:-}" == "--yes" ]] && YES=1

missing() { local p; for p in "$@"; do pacman -Q "$p" >/dev/null 2>&1 || echo "$p"; done; }

mapfile -t BASE_MISSING < <(missing "${BASE_PKGS[@]}")
mapfile -t AUR_MISSING  < <(missing "${AUR_PKGS[@]}")

if ((${#BASE_MISSING[@]} == 0 && ${#AUR_MISSING[@]} == 0)); then
  echo "all continuity-kit packages present"
  echo "--- versions ---"
  pacman -Q kdeconnect scrcpy android-tools syncthing wl-clip-persist localsend-bin 2>/dev/null || true
  exit 0
fi

if ((${#BASE_MISSING[@]})); then
  echo "missing (official): ${BASE_MISSING[*]}"
  echo "command: sudo pacman -Syu --needed ${BASE_MISSING[*]}"
fi

HELPER=""
if command -v yay >/dev/null 2>&1; then HELPER=yay
elif command -v paru >/dev/null 2>&1; then HELPER=paru
fi

if ((${#AUR_MISSING[@]})); then
  echo "missing (AUR): ${AUR_MISSING[*]}"
  if [[ -n "$HELPER" ]]; then
    echo "command: $HELPER -S --needed ${AUR_MISSING[*]}"
  else
    echo "no AUR helper (yay/paru) found; see plan Phase 00 for yay-bin bootstrap"
  fi
fi

if [[ "$YES" -eq 0 ]]; then
  echo
  echo "(dry-run; re-run with --yes to install)"
  exit 0
fi

echo
echo "requesting sudo (you may be prompted)"
sudo -v

if ((${#BASE_MISSING[@]})); then
  sudo pacman -Syu --needed "${BASE_MISSING[@]}"
fi

if ((${#AUR_MISSING[@]})); then
  if [[ -z "$HELPER" ]]; then
    echo "ERROR: AUR packages missing but no AUR helper available" >&2
    exit 1
  fi
  "$HELPER" -S --needed "${AUR_MISSING[@]}"
fi

echo
echo "done. verify with: pacman -Q kdeconnect scrcpy android-tools syncthing"
