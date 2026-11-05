#!/usr/bin/env bash
# Generated runtime for git-habits. Keep command definitions in config/commands.tsv.

git-habits__require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'git-habits: required command not found: %s\n' "$1" >&2
    return 127
  }
}

cl() { clear; }
gad() { git add .; }
gcm() {
  if [ "$#" -eq 0 ]; then
    printf 'Usage: gcm <message>\n' >&2
    return 2
  fi
  git commit -m "$*"
}
gps() { git push "$@"; }
gpl() { git pull "$@"; }
gmg() { git merge "$@"; }
gst() { git status "$@"; }
glg() { git log "$@"; }
gll() { git log --oneline "$@"; }
gcl() { git clone "$@"; }
nrd() { npm run dev "$@"; }
nrb() { npm run build "$@"; }
