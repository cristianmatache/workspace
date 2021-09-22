#!/usr/bin/env bash

run_command_in_background() {
	local command_to_run="$1"
	local logdir="${logdir:-${2:-./}}"
	local file_name
	file_name="$(date --iso)-$(hostname).txt"
	mkdir -p "$logdir"
	eval "nohup $command_to_run &>> \"$logdir/$file_name\" &"
}
