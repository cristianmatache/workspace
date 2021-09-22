#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Kill existing (if any)
kill_process "prometheus.exe" "prometheus --config"
