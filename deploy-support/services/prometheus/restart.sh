#!/usr/bin/env bash
# Windows and Linux

# Imports
CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}")
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"
# shellcheck source=lib_sh_utils/src/commands.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/commands.sh"

# Constants
PROMETHEUS_PORT=":$(echo "${PROMETHEUS_PORT:-7010}" | tr -d ":")" # Remove : if already in PROMETHEUS_PORT
RESOLVED_HOME=$(find_command_home prometheus "$HOME/apps/prometheus" PROMETHEUS_HOME)
RESOLVED_CONFIG="${PROMETHEUS_CONFIG:-${CHECKOUT_ROOT}/deploy-support/services/prometheus/prometheus.yml}"
RESOLVED_RULES="${PROMETHEUS_RULES:-${CHECKOUT_ROOT}/deploy-support/services/prometheus/rules}"

echo "---------------------------------------------------------"
echo "Prometheus home is:   $RESOLVED_HOME"
echo "Prometheus config is: $RESOLVED_CONFIG"
echo "Prometheus rules are: $RESOLVED_RULES"
echo "Prometheus port is:   $PROMETHEUS_PORT"

# Lint Prometheus files
make lint-prometheus promhome="$RESOLVED_HOME"

# Kill existing (if any)
# shellcheck source=deploy-support/services/prometheus/kill.sh
source "$CHECKOUT_ROOT/deploy-support/services/prometheus/kill.sh"

# Run
echo "$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
# --storage.tsdb.path
