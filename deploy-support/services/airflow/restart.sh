#!/usr/bin/env bash
# Linux and WSL only

CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}")
# shellcheck source=deploy-support/services/airflow/kill.sh
source "$CHECKOUT_ROOT/deploy-support/services/airflow/kill.sh"

ENV='/home/cristian/apps/miniconda3/envs/airflow/bin'
export PATH="$ENV":"$PATH"
echo "Using environment: $ENV"

AIRFLOW_BASE="${AIRFLOW_HOME:-~/airflow}"
rm -rf "$AIRFLOW_BASE"/airflow-*.pid
rm -rf "$AIRFLOW_BASE"/airflow-*.err

sleep 1s

airflow scheduler -D
airflow webserver --port 7000 -D
