#!/usr/bin/env bash

run_tests(){
  local BASEDIR="$(dirname ${BASH_SOURCE[0]})"
  cd "$BASEDIR" || exit
  tests=($(find '.' -d 1 -iname '*.bats'))
  bats "${tests[@]}"
}

run_tests
