#!/usr/bin/env bash
# $1: "on" file
# $2: Path to python interpreter ($PyInterpreterDirectory$)
export PATH=$2:$PATH
make fmt on="$1"
