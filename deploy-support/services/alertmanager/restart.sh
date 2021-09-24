#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}")
# shellcheck source=lib_sh_utils/src/commands.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/commands.sh"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
ALERTMANAGER_PORT=":$(echo "${ALERTMANAGER_PORT:-7013}" | tr -d ":")" # Remove : if already in ALERTMANAGER_PORT
RESOLVED_HOME=$(find_command_home alertmanager "$HOME/apps/alertmanager" ALERTMANAGER_HOME)
RESOLVED_CONFIG="${ALERTMANAGER_CONFIG:-${CHECKOUT_ROOT}/deploy-support/services/alertmanager/alertmanager.yml}"

echo "---------------------------------------------------------"
echo "Alertmanager home is:   $RESOLVED_HOME"
echo "Alertmanager config is: $RESOLVED_CONFIG"
echo "Alertmanager port is:   $ALERTMANAGER_PORT"

# Kill existing (if any)
# shellcheck source=deploy-support/services/alertmanager/kill.sh
source "$CHECKOUT_ROOT/deploy-support/services/alertmanager/kill.sh"
sleep 2s

# Run
echo "$RESOLVED_HOME"/alertmanager --config.file "$RESOLVED_CONFIG" --web.listen-address="$ALERTMANAGER_PORT" --data.retention=24h
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/alertmanager --config.file "$RESOLVED_CONFIG" --web.listen-address="$ALERTMANAGER_PORT" --data.retention=24h
# --storage.path
