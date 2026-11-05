#!/usr/bin/env bash
set -euo pipefail

MARKER_START='# >>> git-habits >>>'
MARKER_END='# <<< git-habits <<<'
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-habits"
case "${SHELL:-}" in
  */zsh) PROFILE="${ZDOTDIR:-$HOME}/.zshrc" ;;
  *) PROFILE="${HOME}/.bashrc" ;;
esac

if [ -f "$PROFILE" ]; then
  tmp="$(mktemp "${TMPDIR:-/tmp}/git-habits.XXXXXX")"
  awk -v start="$MARKER_START" -v end="$MARKER_END" '
    $0 == start { skip=1; next }
    $0 == end { skip=0; next }
    !skip { print }
  ' "$PROFILE" > "$tmp"
  if ! cmp -s "$tmp" "$PROFILE"; then
    backup="${PROFILE}.git-habits.bak.$(date +%Y%m%d%H%M%S)"
    cp -- "$PROFILE" "$backup"
    mv -- "$tmp" "$PROFILE"
    printf 'Removed git-habits block from: %s\nBackup: %s\n' "$PROFILE" "$backup"
  else
    rm -f -- "$tmp"
    printf 'No git-habits block found in: %s\n' "$PROFILE"
  fi
fi
if [ -d "$CONFIG_DIR" ]; then
  rm -rf -- "$CONFIG_DIR"
  printf 'Removed generated configuration: %s\n' "$CONFIG_DIR"
else
  printf 'Generated configuration not found: %s\n' "$CONFIG_DIR"
fi
printf 'Existing user configuration and backups were preserved.\n'
