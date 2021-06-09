#!/usr/bin/env bash
# Windows and Linux, run from project root

# Imports
. lib_sh_utils/src/commands.sh
. lib_sh_utils/src/os.sh

# Constants
ALERTMANAGER_PORT=":$(echo "${ALERTMANAGER_PORT:-7013}" | tr -d ":")" # Remove : if already in ALERTMANAGER_PORT
RESOLVED_HOME=$(find_command_home alertmanager "$HOME/alertmanager" ALERTMANAGER_HOME)
RESOLVED_CONFIG="${ALERTMANAGER_CONFIG:-deploy-support/alertmanager/alertmanager.yml}"

echo "---------------------------------------------------------"
echo "Alertmanager home is:   $RESOLVED_HOME"
echo "Alertmanager config is: $RESOLVED_CONFIG"
echo "Alertmanager port is:   $ALERTMANAGER_PORT"

# Kill existing (if any)
. deploy-support/alertmanager/kill.sh

# Run
echo "$RESOLVED_HOME"/alertmanager --config.file "$RESOLVED_CONFIG" --web.listen-address="$ALERTMANAGER_PORT" --data.retention=24h
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/alertmanager --config.file "$RESOLVED_CONFIG" --web.listen-address="$ALERTMANAGER_PORT" --data.retention=24h
# --storage.path
