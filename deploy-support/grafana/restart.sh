#!/usr/bin/env bash
# Windows and Linux, run from project root

# Imports
. lib_sh_utils/src/commands.sh
. lib_sh_utils/src/os.sh

# Constants
RESOLVED_HOME="$(dirname "$(find_command_home grafana-server "$HOME/grafana/bin" GRAFANA_HOME)")"
RESOLVED_CONFIG="${GRAFANA_CONFIG:-deploy-support/grafana/grafana.ini}"
# The port is specified in the config file

echo "---------------------------------------------------------"
echo "Grafana home is:   $RESOLVED_HOME"
echo "Grafana config is: $RESOLVED_CONFIG"

# Kill existing (if any)
. deploy-support/grafana/kill.sh

# Run
echo "$RESOLVED_HOME"/bin/grafana-server -homepath="$RESOLVED_HOME" -config="$RESOLVED_CONFIG"
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/bin/grafana-server -homepath="$RESOLVED_HOME" -config="$RESOLVED_CONFIG"
