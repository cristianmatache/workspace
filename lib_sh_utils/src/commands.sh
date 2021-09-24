#!/usr/bin/env bash

find_command_home() {
	local COMMAND DEFAULT ENV_VAR_NAME ENV_VAR_VAL DEDUCED_HOME
	# all 3 arguments are required
	# 1 COMMAND
	# command that we want to find the "home" directory for: e.g. prometheus
	COMMAND="$1"
	# 2 DEFAULT
	# if we cannot work out the dir from an environment variable (e.g. PROMETHEUS_HOME), nor from $PATH,
	# this will be the default (typically something like "$HOME/apps/prometheus")
	DEFAULT="$2"
	# 3 ENV_VAR_NAME
	# name of environment variable (e.g. PROMETHEUS_HOME)
	# if this variable exists it will be used, otherwise we search the $PATH for the given command, otherwise we return
	# the default
	ENV_VAR_NAME="$3"

	# Work out the value of the env var if any
	ENV_VAR_VAL=$(printf '%s\n' "${!ENV_VAR_NAME}")
	if [[ -n "$ENV_VAR_VAL" ]]; then
		echo "$ENV_VAR_VAL"
		return
	fi

	# If the dir name of the command was not specified as an env var
	# try to work it out
	if command -v "$COMMAND" &>/dev/null; then
		LOC_ON_PATH="$(command -v "$COMMAND")"
		DEDUCED_HOME=$(dirname "$LOC_ON_PATH")
	else
		DEDUCED_HOME="$DEFAULT"
	fi
	echo "$DEDUCED_HOME"
}

assert_command_exists() {
	local COMMAND
	COMMAND="$1"
	if command -v "$COMMAND"; then
		echo "Found $COMMAND at $(command -v "$COMMAND")"
	else
		echo "$COMMAND does not exist"
		exit 1
	fi
}
