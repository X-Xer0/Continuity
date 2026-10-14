# AGENTS.md — rules for any AI/human working in continuity-kit

This repo configures the user's LIVE machine. Read the full execution plan
(CONTINUITY-KIT v1.0) before every session. Max one phase per session.

## Session ritual
1. `cd /home/xer0/continuity-kit && git status && git log --oneline -5`
2. Read `README.md` + this file.
3. Pick the next unfinished phase. Never skip. Never batch two phases.
4. If env may have changed, re-run `install/00-preflight.sh` first.

## Change safety
- Backup before edit: `cp -a FILE FILE.bak.$(date +%Y%m%d-%H%M%S)` + central copy
  under `~/.local/state/continuity-kit/backups/<timestamp>/`.
- Only `install/30-apply-config.sh --apply` may modify files outside this repo.
- Never `rm -rf`, never overwrite, never `>`-truncate files you did not create.
  To "remove": move to backups.
- Never edit `/etc/*` without backup + shown diff + explicit user confirmation.
- Never `git push`, force-push, or rewrite history.

## Privileges
- Test `sudo -n true` first. If password needed: print the exact command block,
  ask the user to run it, paste output back. Never pipe passwords.
- Never store/log passwords, Wi-Fi creds, ADB codes, SMS content, device IDs.

## Scripts
- `#!/usr/bin/env bash` + `set -euo pipefail`. Idempotent. `--dry-run` default
  for home-config writers. Quote expansions. `local` in functions.
- No hardcoded `/home/xer0` inside scripts; use `$HOME`, `$XDG_*`.
- Log to `~/.local/state/continuity-kit/logs/`.
- Must pass `bash -n` and `shellcheck -S warning` (`tests/smoke.sh`).

## Git
- Conventional commits: `feat(phase-N): ...`, `fix(...)`, `docs(...)`, `test(...)`.
- Never commit secrets, device IDs, IPs, ADB keys, SMS exports.

## Reporting (after every phase)
```
PHASE <n> — <name>: DONE / BLOCKED
Actions: <bullets>
Evidence: <raw command output>
Files changed: <paths>
Next: PHASE <n+1>
Blockers: <none | question>
```
Never fabricate evidence.
