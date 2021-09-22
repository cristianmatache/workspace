#!/usr/bin/env bash

CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../..}"
. "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

run_through_ssh() {
	local username="${3:-${SSH_USER_TO_RUN_COMMAND:-$(whoami)}}"
	local ssh_private_key="${SSH_PRIVATE_KEY_PATH:-$(get_default_private_ssh_key_path "$username")}"
	local command_to_run="${1:-${SSH_COMMAND_TO_RUN:-hostname}}"
	local hosts="${2:-${SSH_HOSTS_TO_RUN_COMMAND:-$(hostname)}}"
	echo "Running \"$command_to_run\" as $username over hosts: $hosts"
	local host
	for host in $hosts; do
		echo "Host: $host"
		ssh -i "$ssh_private_key" "$username@$host" "$command_to_run"
	done
}

get_default_private_ssh_key_path() {
	local username="$1"
	if [[ "$(get_running_os)" == "windows" ]]; then
		echo ~/.ssh/id_rsa
	else
		echo "~$username/.ssh/id_rsa"
	fi
}
