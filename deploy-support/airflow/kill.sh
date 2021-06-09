#!/usr/bin/env bash
# Linux and WSL only

pkill -f "airflow webserver" && echo "Airflow webserver was killed"
pkill -f "airflow scheduler" && echo "Airflow scheduler was killed"

sleep 2s
