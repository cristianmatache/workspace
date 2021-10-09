#!/usr/bin/env bash

run_command_in_background() {
	local command_to_run="$1"
	local log_dir="${log_dir:-${2:-./}}"
	local file_name
	file_name="$(date --iso)-$(hostname).txt"
	mkdir -p "$log_dir"
	local command_in_background="nohup $command_to_run > \"$log_dir/$file_name\" 2>&1 &"
	echo "$command_in_background"
	#	set -x  # use echo for ansible
	eval "$command_in_background"
	#	set +x  # use echo for ansible
}
