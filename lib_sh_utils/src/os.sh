#!/usr/bin/env bash

get_running_os() {
	uname_out="$(uname -s)"
	case "${uname_out}" in
	Linux*) machine=Linux ;;
	Darwin*) machine=Mac ;;
	CYGWIN*) machine=Windows ;;
	MINGW*) machine=Windows ;;
	*) machine="UNKNOWN:${uname_out}" ;;
	esac
	echo "${machine}" | tr '[:upper:]' '[:lower:]'
}

kill_process() {
	local existing_pid windows_pattern linux_pattern
	# Kill a process on Windows (with git bash), WSL and Linux
	# the pkill patterns for windows and linux/wsl are different (specified as argument)
	windows_pattern="$1"
	linux_pattern="$2"

	if [[ "$(get_running_os)" == 'windows' ]]; then
		existing_pid=$(tasklist | grep "$windows_pattern" | awk '{print $2}')
		if [[ -n "$existing_pid" ]]; then
			echo "Prometheus is running with PID: $existing_pid -> Killing it"
			# This forcibly kills the process which is not great but it's windows so hopefully no one is using it
			taskkill //f //pid "$existing_pid" && echo "Killed Prometheus $existing_pid"
		fi
	else
		existing_pid=$(pgrep -f "$linux_pattern")
		if [[ -n "$existing_pid" ]]; then
			echo "Prometheus is running with PID: $existing_pid -> Killing it"
			pkill -f "$linux_pattern" && echo "Killed pattern: $linux_pattern"
		fi
	fi
}
