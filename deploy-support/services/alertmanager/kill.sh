#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Kill existing (if any)
kill_process "alertmanager.exe" "alertmanager --config"
