#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"
# shellcheck source=lib_sh_utils/src/commands.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/commands.sh"

# Constants
NODE_EXPORTER_PORT=":$(echo "${NODE_EXPORTER_PORT:-7016}" | tr -d ":")" # Remove : if already in NODE_EXPORTER_PORT
RESOLVED_HOME=$(find_command_home prometheus "$HOME/apps/node_exporter" NODE_EXPORTER_HOME)

echo "---------------------------------------------------------"
echo "node_exporter home is:   $RESOLVED_HOME"
echo "node_exporter config is: $RESOLVED_CONFIG"
echo "node_exporter rules are: $RESOLVED_RULES"
echo "node_exporter port is:   $NODE_EXPORTER_PORT"

# Kill existing (if any)
# shellcheck source=deploy-support/services/node_exporter/kill.sh
source "$CHECKOUT_ROOT/deploy-support/services/node_exporter/kill.sh"
sleep 2s

# Run
echo "$RESOLVED_HOME"/node_exporter --web.listen-address="$NODE_EXPORTER_PORT"
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/node_exporter --web.listen-address="$NODE_EXPORTER_PORT"
