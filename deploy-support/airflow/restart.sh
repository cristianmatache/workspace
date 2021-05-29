#!/usr/bin/env bash
# Linux and WSL only

pkill -f "airflow webserver" && echo "Airflow webserver was killed" || echo "Airflow webserver was not running"
pkill -f "airflow scheduler" && echo "Airflow scheduler was killed" || echo "Airflow scheduler was not running"

sleep 2s

ENV='/home/cristian/apps/miniconda3/envs/airflow/bin'
export PATH="$ENV":"$PATH"
echo "Using environment: $ENV"

AIRFLOW_BASE="${AIRFLOW_HOME:-~/airflow}"
rm -rf "$AIRFLOW_BASE/airflow-*"

airflow webserver --port 7000 -D
airflow scheduler -D
