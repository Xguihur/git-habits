#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MARKER_START='# >>> git-habits >>>'
MARKER_END='# <<< git-habits <<<'
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-habits"

backup_once() {
  local file="$1"
  [ -f "$file" ] || return 0
  local backup="${file}.git-habits.bak"
  if [ -e "$backup" ]; then backup="${file}.git-habits.bak.$(date +%Y%m%d%H%M%S)"; fi
  cp -- "$file" "$backup"
  printf 'Backup: %s\n' "$backup"
}

replace_block() {
  local file="$1" block="$2" tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/git-habits.XXXXXX")"
  if [ -f "$file" ]; then
    awk -v start="$MARKER_START" -v end="$MARKER_END" '
      $0 == start { skip=1; next }
      $0 == end { skip=0; next }
      !skip { print }
    ' "$file" > "$tmp"
  fi
  printf '%s\n' "$block" >> "$tmp"
  mkdir -p -- "$(dirname -- "$file")"
  if [ -f "$file" ] && cmp -s "$tmp" "$file"; then rm -f -- "$tmp"; return 0; fi
  backup_once "$file"
  mv -- "$tmp" "$file"
  printf 'Updated: %s\n' "$file"
}

case "${SHELL:-}" in
  */zsh) PROFILE="${ZDOTDIR:-$HOME}/.zshrc" ;;
  *) PROFILE="${HOME}/.bashrc" ;;
esac
mkdir -p -- "$CONFIG_DIR"
cp -- "$ROOT_DIR/shell/git-habits.sh" "$CONFIG_DIR/git-habits.sh"
chmod 0644 "$CONFIG_DIR/git-habits.sh"
replace_block "$PROFILE" "$MARKER_START
source \"$CONFIG_DIR/git-habits.sh\"
$MARKER_END"
printf 'Installed shell commands from %s\n' "$CONFIG_DIR/git-habits.sh"
printf 'Detected shell profile: %s\n' "$PROFILE"
printf 'Open a new shell or run: . %q\n' "$PROFILE"
