#!/usr/bin/env bats

setup() {
  load '3rdparty/sh-env-ws/node_modules/bats-support/load.bash'
  load '3rdparty/sh-env-ws/node_modules/bats-assert/load.bash'

}

get_default_home() {
  . lib_sh_utils/src/commands.sh
  find_command_home theCommand theDefault theEnvVar
}

@test "find_command_home: gets the default" {
    run get_default_home
    assert_output 'theDefault'
}

get_from_env_var() {
  . lib_sh_utils/src/commands.sh
  export theEnvVar="fromEnvVar"
  find_command_home theCommand theDefault theEnvVar
}

@test "find_command_home: get from env var" {
  run get_from_env_var
  assert_output "fromEnvVar"
}

get_from_path() {
  . lib_sh_utils/src/commands.sh
  find_command_home bats theDefault theEnvVar
}

@test "find_command_home: get from \$PATH" {
  run get_from_path
  assert_output "$(pwd)/3rdparty/sh-env-ws/node_modules/bats/libexec/bats-core"
}