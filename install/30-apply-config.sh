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

# ---------- 4. kdeconnect per-device config ----------
say
say "== 4. kdeconnect device config =="
if ! command -v kdeconnect-cli >/dev/null 2>&1; then
  say "WARN: kdeconnect-cli not found; skipping"
else
  mapfile -t dev_ids < <(kdeconnect-cli -l --id-only 2>/dev/null || true)
  if ((${#dev_ids[@]} == 0)); then
    say "no paired devices yet; re-run after pairing (android/CHECKLIST.md)"
  fi
  for id in "${dev_ids[@]}"; do
    share_dir="$HOME/.config/kdeconnect/$id/kdeconnect_share"
    share_cfg="$share_dir/config"
    want="[General]
incoming_path=$HOME/continuity"
    if [[ -f "$share_cfg" ]] && [[ "$(cat "$share_cfg")" == "$want" ]]; then
      say "ok (already current): $share_cfg"
    else
      say "would install: $share_cfg"
      backup "$share_cfg"
      if [[ "$MODE" == apply ]]; then
        mkdir -p "$share_dir" "$HOME/continuity"
        printf '%s\n' "$want" > "$share_cfg"
        changed=1
      fi
    fi

    rc_dir="$HOME/.config/kdeconnect/$id/kdeconnect_runcommand"
    rc_cfg="$rc_dir/config"
    if cmp -s "$REPO/configs/kdeconnect/runcommand-config" "$rc_cfg" 2>/dev/null; then
      say "ok (already current): $rc_cfg"
    else
      say "would install: $rc_cfg (safe command allowlist)"
      backup "$rc_cfg"
      if [[ "$MODE" == apply ]]; then
        mkdir -p "$rc_dir"
        cp "$REPO/configs/kdeconnect/runcommand-config" "$rc_cfg"
        changed=1
      fi
    fi
  done
fi

# ---------- 5. localsend preferences ----------
say
say "== 5. localsend preferences =="
LS_PREF="$HOME/.local/share/org.localsend.localsend_app/shared_preferences.json"
if [[ ! -f "$LS_PREF" ]]; then
  say "WARN: $LS_PREF not found (launch LocalSend once, then re-run); skipping"
else
  say "would set: quick_save=on (QuickSaveMode), destination=$HOME/continuity, minimize_to_tray=true"
  backup "$LS_PREF"
  if [[ "$MODE" == apply ]]; then
    out="$(python3 - "$LS_PREF" <<'PY'
import json, pathlib, sys
p = pathlib.Path(sys.argv[1])
d = json.loads(p.read_text())
before = {k: d.get(k) for k in ("flutter.ls_quick_save", "flutter.ls_destination", "flutter.ls_minimize_to_tray")}
# LocalSend expects: quick_save = QuickSaveMode string (off|on|paired),
# destination = string, minimize_to_tray = bool. Writing a bool for quick_save
# crashes the app at startup ("type 'bool' is not a subtype of type 'String?'").
d["flutter.ls_quick_save"] = "on"
d["flutter.ls_destination"] = str(pathlib.Path.home() / "continuity")
d["flutter.ls_minimize_to_tray"] = True
assert isinstance(d["flutter.ls_quick_save"], str)
p.write_text(json.dumps(d, indent=4))
after = {k: d.get(k) for k in before}
print(("changed" if before != after else "no change needed") + f": {after}")
PY
)"
    say "$out"
    [[ "$out" == changed* ]] && changed=1
    say "note: restart LocalSend if it is running (it rewrites prefs on exit)"
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
