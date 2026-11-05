#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_HOME="$(mktemp -d "${TMPDIR:-/tmp}/git-habits-test.XXXXXX")"
trap 'rm -rf "$TEST_HOME"' EXIT
mkdir -p "$TEST_HOME/.config"
printf 'user setting\n' > "$TEST_HOME/.bashrc"
HOME="$TEST_HOME" SHELL=/bin/bash XDG_CONFIG_HOME="$TEST_HOME/.config" "$ROOT_DIR/install.sh" >/tmp/git-habits-install.out
[ "$(grep -c '^# >>> git-habits >>>$' "$TEST_HOME/.bashrc")" -eq 1 ]
[ -f "$TEST_HOME/.config/git-habits/git-habits.sh" ]

HOME="$TEST_HOME" SHELL=/bin/bash XDG_CONFIG_HOME="$TEST_HOME/.config" "$ROOT_DIR/install.sh" >/tmp/git-habits-install-again.out
[ "$(grep -c '^# >>> git-habits >>>$' "$TEST_HOME/.bashrc")" -eq 1 ]

env HOME="$TEST_HOME" SHELL=/bin/bash XDG_CONFIG_HOME="$TEST_HOME/.config" bash --noprofile --norc -c '. "$HOME/.config/git-habits/git-habits.sh"; type gcm; type gst; gcm' >/tmp/git-habits-gcm.out 2>&1 || [ "$?" -eq 2 ]
grep -q 'Usage: gcm <message>' /tmp/git-habits-gcm.out

env HOME="$TEST_HOME" SHELL=/bin/bash XDG_CONFIG_HOME="$TEST_HOME/.config" "$ROOT_DIR/uninstall.sh" >/tmp/git-habits-uninstall.out
[ "$(grep -c '^# >>> git-habits >>>$' "$TEST_HOME/.bashrc" || true)" -eq 0 ]
grep -q '^user setting$' "$TEST_HOME/.bashrc"
[ ! -e "$TEST_HOME/.config/git-habits" ]
printf 'smoke tests passed\n'
