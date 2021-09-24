#!/usr/bin/env bash
# Linux only

# Imports
CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Kill existing (if any)
kill_process "not-available-on-windows" "node_exporter --web.listen-address"
