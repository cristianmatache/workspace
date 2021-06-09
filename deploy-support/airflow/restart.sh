#!/usr/bin/env bash
# Linux and WSL only, run from project root

. deploy-support/airflow/kill.sh

ENV='/home/cristian/apps/miniconda3/envs/airflow/bin'
export PATH="$ENV":"$PATH"
echo "Using environment: $ENV"

AIRFLOW_BASE="${AIRFLOW_HOME:-~/airflow}"
rm -rf "$AIRFLOW_BASE/airflow-*"

airflow webserver --port 7000 -D
airflow scheduler -D
