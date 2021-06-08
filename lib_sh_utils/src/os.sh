#!/usr/bin/env bash

get_running_os() {
  uname_out="$(uname -s)"
  case "${uname_out}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Windows;;
      MINGW*)     machine=Windows;;
      *)          machine="UNKNOWN:${uname_out}"
  esac
  echo "${machine}" | tr '[:upper:]' '[:lower:]'
}