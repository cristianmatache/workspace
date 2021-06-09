#!/usr/bin/env bash
# Windows and Linux, run from project root

# Imports
. lib_sh_utils/src/os.sh

# Kill existing (if any)
kill_process "grafana-server.exe" "grafana-server -homepath"
