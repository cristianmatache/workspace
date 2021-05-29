#!/usr/bin/env bash
# Windows and Linux
PROMETHEUS_PORT=":$(echo "${PROMETHEUS_PORT:-7010}" | tr -d ":")"  # Remove : if already in PROMETHEUS_PORT

echo "---------------------------------------------------------"
if command -v prometheus &> /dev/null
then
  echo "Prometheus is on \$PATH"
  PROMETHEUS_LOC_ON_PATH="$(which prometheus)"
  DEDUCED_HOME=$(dirname "$PROMETHEUS_LOC_ON_PATH")
fi
RESOLVED_HOME="${PROMETHEUS_HOME:-${DEDUCED_HOME:-${HOME}/prometheus}}"
RESOLVED_CONFIG="${PROMETHEUS_CONFIG:-deploy-support/prometheus/prometheus.yml}"
echo "Prometheus home is: $RESOLVED_HOME"
echo "Prometheus config is: $RESOLVED_CONFIG"
echo "Prometheus port is: $PROMETHEUS_PORT"

# Sync config file
cp "$RESOLVED_CONFIG" "$RESOLVED_HOME" && echo "Synchronized config file $RESOLVED_CONFIG to $RESOLVED_HOME"

# Run
echo "$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
echo "---------------------------------------------------------"
"$RESOLVED_HOME"/prometheus --config.file "$RESOLVED_CONFIG" --web.listen-address="$PROMETHEUS_PORT" --storage.tsdb.retention.time=1d
# --storage.tsdb.path