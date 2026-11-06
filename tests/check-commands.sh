#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TSV="$ROOT_DIR/config/commands.tsv"
SHELL_RUNTIME="$ROOT_DIR/shell/git-habits.sh"
PS_RUNTIME="$ROOT_DIR/shell/git-habits.ps1"

awk 'BEGIN { FS = sprintf("%c", 9) }
  /^#/ { next }
  {
    if (NF != 6) { printf "invalid TSV row %d: expected 6 columns\n", NR > "/dev/stderr"; exit 1 }
    if ($1 == "" || $2 == "" || $3 == "") { printf "invalid TSV row %d: required field is empty\n", NR > "/dev/stderr"; exit 1 }
    if ($1 in seen) { printf "duplicate command name: %s\n", $1 > "/dev/stderr"; exit 1 }
    seen[$1] = 1
    count++
  }
  END { if (count != 12) { printf "expected 12 commands, found %d\n", count > "/dev/stderr"; exit 1 } }
' "$TSV"

while IFS=$'\t' read -r name _; do
  [ -z "$name" ] && continue
  case "$name" in \#*) continue ;; esac
  grep -Eq "^${name}[[:space:]]*\(\)" "$SHELL_RUNTIME" || { printf 'missing shell runtime: %s\n' "$name" >&2; exit 1; }
  grep -Eq "^function ${name}[[:space:]]*\{" "$PS_RUNTIME" || { printf 'missing PowerShell runtime: %s\n' "$name" >&2; exit 1; }
done < "$TSV"
printf 'command consistency check passed\n'
