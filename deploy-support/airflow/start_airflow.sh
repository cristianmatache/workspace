#!/usr/bin/env bash

ENV='/home/cristian/apps/miniconda3/envs/airflow/bin'
export PATH="$ENV":"$PATH"
echo "Using environment: $ENV"

AIRFLOW_BASE="${AIRFLOW_HOME:-~/airflow}"
rm -rf "$AIRFLOW_BASE/airflow-*"

airflow webserver --port 7000 -D
airflow scheduler -D