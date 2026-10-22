#!/usr/bin/env bash
# 90-uninstall.sh — safe reverse of continuity-kit.
# Usage:
#   ./install/90-uninstall.sh              # show state (default)
#   ./install/90-uninstall.sh --remove-links
#   ./install/90-uninstall.sh --restore    # restore latest backup set
#   ./install/90-uninstall.sh --packages   # print package removal commands (does not run)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/continuity-kit"

mode="${1:---show}"
case "$mode" in
  --remove-links)
    for src in "$REPO"/bin/ck-*; do
      name="$(basename "$src")"
      dst="$HOME/.local/bin/$name"
      if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        rm -f "$dst"
        echo "removed link: $dst"
      fi
    done
    ;;
  --restore)
    exec "$REPO/install/30-apply-config.sh" --restore
    ;;
  --packages)
    cat <<'EOF'
# Removal commands (run manually if you really want them gone):
yay -Rns localsend-bin localsend-cli-bin 2>/dev/null || true
sudo pacman -Rns kdeconnect scrcpy android-tools wl-clip-persist \
  zenity sshfs shellcheck 2>/dev/null || true
# keep: wl-clipboard, cliphist, portals, bluez, pipewire (used by your desktop too)
EOF
    ;;
  --show|*)
    echo "continuity-kit uninstall helper (nothing changed)"
    echo
    echo "symlinks pointing into this repo:"
    found=0
    for src in "$REPO"/bin/ck-*; do
      name="$(basename "$src")"
      dst="$HOME/.local/bin/$name"
      if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        echo "  $dst"
        found=1
      fi
    done
    ((found)) || echo "  (none)"
    echo
    echo "backup sets in $STATE/backups:"
    ls -1 "$STATE/backups" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    echo
    echo "options: --remove-links | --restore | --packages"
    ;;
esac
