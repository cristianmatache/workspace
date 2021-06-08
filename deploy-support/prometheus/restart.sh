#!/usr/bin/env bash
# Windows and Linux, run from project root

# Imports
. lib_sh_utils/src/commands.sh

# Constants
PROMETHEUS_PORT=":$(echo "${PROMETHEUS_PORT:-7010}" | tr -d ":")"  # Remove : if already in PROMETHEUS_PORT
RESOLVED_HOME=$(find_command_home prometheus "$HOME/prometheus" PROMETHEUS_HOME)
RESOLVED_CONFIG="${PROMETHEUS_CONFIG:-deploy-support/prometheus/prometheus.yml}"
RESOLVED_RULES="${PROMETHEUS_RULES:-deploy-support/prometheus/rules}"

echo "---------------------------------------------------------"
echo "Prometheus home is:   $RESOLVED_HOME"
echo "Prometheus config is: $RESOLVED_CONFIG"
echo "Prometheus rules are: $RESOLVED_RULES"
echo "Prometheus port is:   $PROMETHEUS_PORT"

# Lint Prometheus files
make lint-prometheus promhome="$RESOLVED_HOME"

# Sync config file
cp "$RESOLVED_CONFIG" "$RESOLVED_HOME" && echo "Synchronized config file $RESOLVED_CONFIG to $RESOLVED_HOME"
# Sync rules files
cp -r "$RESOLVED_RULES" "$RESOLVED_HOME" && echo "Synchronized rules files $RESOLVED_RULES to $RESOLVED_HOME"  # TODO: use rsync

# Run
echo "$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
# --storage.tsdb.path