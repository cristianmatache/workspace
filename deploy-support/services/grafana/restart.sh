#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}")
# shellcheck source=lib_sh_utils/src/commands.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/commands.sh"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
RESOLVED_HOME="$(dirname "$(find_command_home grafana-server "$HOME/grafana/bin" GRAFANA_HOME)")"
RESOLVED_CONFIG="${GRAFANA_CONFIG:-${CHECKOUT_ROOT}/deploy-support/services/grafana/grafana.ini}"
# The port is specified in the config file

echo "---------------------------------------------------------"
echo "Grafana home is:   $RESOLVED_HOME"
echo "Grafana config is: $RESOLVED_CONFIG"

# Kill existing (if any)
# shellcheck source=deploy-support/services/grafana/kill.sh
source "$CHECKOUT_ROOT/deploy-support/services/grafana/kill.sh"

# Run
echo "$RESOLVED_HOME"/bin/grafana-server -homepath="$RESOLVED_HOME" -config="$RESOLVED_CONFIG"
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/bin/grafana-server -homepath="$RESOLVED_HOME" -config="$RESOLVED_CONFIG"
