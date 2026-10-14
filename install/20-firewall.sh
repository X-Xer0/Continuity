#!/usr/bin/env bash
# 20-firewall.sh — continuity-kit firewall helper.
# Detects ufw / firewalld and prints (or applies with --yes) the scoped rules.
# If no firewall manager is active, points at the manual nftables template.
# Usage:
#   ./install/20-firewall.sh          # show what would be done
#   ./install/20-firewall.sh --yes    # apply rules (prompts for sudo)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
YES=0
[[ "${1:-}" == "--yes" ]] && YES=1

ufw_active=0; fw_active=0
systemctl is-active --quiet ufw 2>/dev/null && ufw_active=1
systemctl is-active --quiet firewalld 2>/dev/null && fw_active=1

if ((ufw_active)); then
  echo "ufw detected (active). Rules:"
  cat <<'EOF'
  sudo ufw allow 1714:1764/tcp comment 'kdeconnect'
  sudo ufw allow 1714:1764/udp comment 'kdeconnect'
  sudo ufw allow 53317/tcp comment 'localsend'
  sudo ufw allow 53317/udp comment 'localsend'
  sudo ufw allow 22000/tcp comment 'syncthing'
  sudo ufw allow 22000/udp comment 'syncthing'
  sudo ufw allow 21027/udp comment 'syncthing-discovery'
EOF
  if ((YES)); then
    sudo -v
    sudo ufw allow 1714:1764/tcp comment 'kdeconnect'
    sudo ufw allow 1714:1764/udp comment 'kdeconnect'
    sudo ufw allow 53317/tcp comment 'localsend'
    sudo ufw allow 53317/udp comment 'localsend'
    sudo ufw allow 22000/tcp comment 'syncthing'
    sudo ufw allow 22000/udp comment 'syncthing'
    sudo ufw allow 21027/udp comment 'syncthing-discovery'
    sudo ufw status numbered
  fi
elif ((fw_active)); then
  echo "firewalld detected (active). Rules:"
  cat <<'EOF'
  sudo firewall-cmd --permanent --add-port=1714-1764/tcp --add-port=1714-1764/udp
  sudo firewall-cmd --permanent --add-port=53317/tcp --add-port=53317/udp
  sudo firewall-cmd --permanent --add-port=22000/tcp --add-port=22000/udp
  sudo firewall-cmd --permanent --add-port=21027/udp
  sudo firewall-cmd --reload
EOF
  if ((YES)); then
    sudo -v
    sudo firewall-cmd --permanent --add-port=1714-1764/tcp --add-port=1714-1764/udp
    sudo firewall-cmd --permanent --add-port=53317/tcp --add-port=53317/udp
    sudo firewall-cmd --permanent --add-port=22000/tcp --add-port=22000/udp
    sudo firewall-cmd --permanent --add-port=21027/udp
    sudo firewall-cmd --reload
    sudo firewall-cmd --list-ports
  fi
else
  echo "no active ufw/firewalld manager detected."
  if command -v nft >/dev/null 2>&1; then
    echo "nftables binary present but no active ruleset managed here."
  fi
  echo "reference template (manual review, do NOT paste blindly):"
  echo "  $REPO/configs/firewall/nftables-continuity.conf"
  echo "nothing changed. This is expected on this machine (no active firewall)."
fi
