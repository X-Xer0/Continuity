#!/usr/bin/env bash
# 30-apply-config.sh — the ONLY writer of files outside this repo.
# Usage:
#   ./install/30-apply-config.sh            # dry-run (default): show what would change
#   ./install/30-apply-config.sh --apply    # apply changes (backs up every file first)
#   ./install/30-apply-config.sh --restore  # restore the latest backup set
#   ./install/30-apply-config.sh --restore <timestamp>
#
# Changes made under --apply:
#   1. symlink bin/ck-*            -> ~/.local/bin/
#   2. configs/hypr/continuity.conf -> ~/.config/hypr/UserConfigs/02-Continuity.conf
#      + a `source = $UserConfigs/02-Continuity.conf` line in ~/.config/hypr/hyprland.conf
#   3. configs/waybar/continuity.jsonc -> ~/.config/waybar/continuity.jsonc
#      + include entry + "custom/continuity" in modules-right of ~/.config/waybar/config
# It never touches: style.css, portal configs, user keybinds/startup files.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/continuity-kit"
BACKUPS="$STATE/backups"
mkdir -p "$BACKUPS" "$STATE/logs"

MODE=dry
case "${1:-}" in
  --apply)   MODE=apply ;;
  --restore) MODE=restore ;;
  --dry-run|"") MODE=dry ;;
  *) echo "usage: $0 [--apply|--restore [timestamp]|--dry-run]" >&2; exit 2 ;;
esac

HOME_LOCALBIN="$HOME/.local/bin"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
HYPR_USERDIR="$HOME/.config/hypr/UserConfigs"
WAYBAR_DIR="$HOME/.config/waybar"

say() { printf '%s\n' "$*"; }
changed=0

# ---------- restore ----------
if [[ "$MODE" == restore ]]; then
  ts="${2:-}"
  [[ -z "$ts" ]] && ts="$(find "$BACKUPS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort | tail -1)"
  [[ -z "$ts" || ! -d "$BACKUPS/$ts" ]] && { echo "no backup set found in $BACKUPS" >&2; exit 1; }
  say "restoring from $BACKUPS/$ts"
  while IFS= read -r rel; do
    src="$BACKUPS/$ts/$rel"
    dst="/${rel}"
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
    say "restored: $dst"
  done < <(cd "$BACKUPS/$ts" && find . \( -type f -o -type l \) -printf '%P\n')
  say "done. Run 'hyprctl reload' and restart waybar if configs changed."
  exit 0
fi

TS="$(date +%Y%m%d-%H%M%S)"
BK="$BACKUPS/$TS"
backup() { # backup <abs-path>; records under $BK using path-without-leading-slash
  local f="$1"
  [[ "$MODE" == apply ]] || return 0   # dry-run must not write anything
  [[ -e "$f" || -L "$f" ]] || return 0
  local rel="${f#/}"
  mkdir -p "$BK/$(dirname "$rel")"
  cp -a "$f" "$BK/$rel"
}

# ---------- 1. symlink bin/ck-* ----------
say "== 1. scripts -> $HOME_LOCALBIN =="
shopt -s nullglob
for src in "$REPO"/bin/ck-*; do
  name="$(basename "$src")"
  dst="$HOME_LOCALBIN/$name"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    say "ok (already linked): $name"
    continue
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    say "would back up existing: $dst"
    backup "$dst"
    [[ "$MODE" == apply ]] || continue
    rm -f "$dst"
  fi
  say "would link: $name"
  if [[ "$MODE" == apply ]]; then
    mkdir -p "$HOME_LOCALBIN"
    ln -s "$src" "$dst"
    changed=1
  fi
done
shopt -u nullglob

# ---------- 2. hyprland ----------
say
say "== 2. hyprland config =="
if [[ ! -f "$HYPR_CONF" ]]; then
  say "WARN: $HYPR_CONF not found; skipping hypr integration"
else
  target="$HYPR_USERDIR/02-Continuity.conf"
  if [[ -f "$target" ]] && cmp -s "$REPO/configs/hypr/continuity.conf" "$target"; then
    say "ok (already current): $target"
  else
    say "would install: $target"
    backup "$target"
    if [[ "$MODE" == apply ]]; then
      cp "$REPO/configs/hypr/continuity.conf" "$target"
      changed=1
    fi
  fi
  if grep -q '02-Continuity.conf' "$HYPR_CONF"; then
    say "ok (source line present): $HYPR_CONF"
  else
    say "would append source line to: $HYPR_CONF"
    backup "$HYPR_CONF"
    if [[ "$MODE" == apply ]]; then
      {
        echo
        echo "# continuity-kit"
        echo 'source = $UserConfigs/02-Continuity.conf'
      } >> "$HYPR_CONF"
      changed=1
    fi
  fi
fi

# ---------- 3. waybar ----------
say
say "== 3. waybar config =="
if [[ ! -f "$WAYBAR_DIR/config" ]]; then
  say "WARN: $WAYBAR_DIR/config not found; skipping waybar integration"
else
  if cmp -s "$REPO/configs/waybar/continuity.jsonc" "$WAYBAR_DIR/continuity.jsonc" 2>/dev/null; then
    say "ok (already current): continuity.jsonc"
  else
    say "would install: $WAYBAR_DIR/continuity.jsonc"
    backup "$WAYBAR_DIR/continuity.jsonc"
    [[ "$MODE" == apply ]] && cp "$REPO/configs/waybar/continuity.jsonc" "$WAYBAR_DIR/continuity.jsonc"
  fi

  if grep -q 'continuity.jsonc' "$WAYBAR_DIR/config" && grep -q 'custom/continuity' "$WAYBAR_DIR/config"; then
    say "ok (already integrated): $WAYBAR_DIR/config"
  else
    say "would edit: $WAYBAR_DIR/config (include + modules-right)"
    backup "$WAYBAR_DIR/config"
    if [[ "$MODE" == apply ]]; then
      python3 - "$WAYBAR_DIR/config" <<'PY'
import re, sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
orig = s
if '"continuity.jsonc"' not in s:
    s, n = re.subn(
        r'(\n(\s*)"\$HOME/\.config/waybar/UserModules",)',
        r'\1\n\2"$HOME/.config/waybar/continuity.jsonc",',
        s)
    if n == 0:
        print("WARN: could not find UserModules include line; manual edit needed")
if '"custom/continuity"' not in s:
    s, n = re.subn(
        r'("modules-right"\s*:\s*\[\s*\n)(\s*)"tray",',
        r'\1\2"tray",\n\2"custom/continuity",',
        s)
    if n == 0:
        print("WARN: could not find modules-right/tray; manual edit needed")
if s != orig:
    open(p, 'w', encoding='utf-8').write(s)
    print("edited:", p)
else:
    print("no change needed")
PY
      changed=1
    fi
  fi
fi

say
if [[ "$MODE" == dry ]]; then
  say "dry-run complete. Re-run with --apply to make changes."
else
  say "apply complete. Backups: $BK"
  say "Next: hyprctl reload && killall -SIGUSR2 waybar (or re-login)"
  if ((changed == 0)); then say "(nothing changed)"; fi
  echo "$(date -Is) apply-config: mode=$MODE changed=$changed backup=$BK" >> "$STATE/activity.log"
fi
