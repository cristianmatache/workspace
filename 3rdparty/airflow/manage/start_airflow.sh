#!/usr/bin/env bash

ENV='/home/cristian/apps/miniconda3/envs/airflow/bin'
export PATH="$ENV":"$PATH"

airflow webserver --port 7000 -D
airflow scheduler -D