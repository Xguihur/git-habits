#!/usr/bin/env bash
set -euo pipefail
exec "$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/install.sh" "$@"
