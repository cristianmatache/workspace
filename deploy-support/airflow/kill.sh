#!/usr/bin/env bash
# Linux and WSL only

pkill -f "airflow webserver" && echo "Airflow webserver was killed"
pkill -f "airflow scheduler" && echo "Airflow scheduler was killed"

AIRFLOW_HOME="${AIRFLOW_HOME:-$HOME/airflow}"
rm -rf "$AIRFLOW_HOME"/*.pid

sleep 2s
