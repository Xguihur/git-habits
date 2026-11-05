#!/usr/bin/env bash
set -u
MARKER_START='# >>> git-habits >>>'
MARKER_END='# <<< git-habits <<<'
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-habits"
case "${SHELL:-}" in
  */zsh) SHELL_NAME=zsh; PROFILE="${ZDOTDIR:-$HOME}/.zshrc" ;;
  */bash|*) SHELL_NAME=bash; PROFILE="${HOME}/.bashrc" ;;
esac
printf 'OS: %s\n' "$(uname -s 2>/dev/null || printf unknown)"
printf 'Shell: %s\n' "$SHELL_NAME"
printf 'Profile: %s\n' "$PROFILE"
check() { if command -v "$1" >/dev/null 2>&1; then printf 'OK: %s (%s)\n' "$1" "$(command -v "$1")"; else printf 'MISSING: %s\n' "$1"; fi; }
check git
check npm
if [ -f "$PROFILE" ] && grep -Fqx "$MARKER_START" "$PROFILE" && grep -Fqx "$MARKER_END" "$PROFILE"; then printf 'OK: loading block found\n'; else printf 'MISSING: loading block in profile\n'; fi
if [ -f "$CONFIG_DIR/git-habits.sh" ]; then printf 'OK: generated shell config: %s\n' "$CONFIG_DIR/git-habits.sh"; else printf 'MISSING: generated shell config: %s\n' "$CONFIG_DIR/git-habits.sh"; fi
for command_name in cl gad gcm gps gpl gmg gst glg gll gcl nrd nrb; do
  if type "$command_name" >/dev/null 2>&1; then printf 'OK: command %s\n' "$command_name"; else printf 'NOTE: command %s is unavailable in this shell (reload profile?)\n' "$command_name"; fi
done
