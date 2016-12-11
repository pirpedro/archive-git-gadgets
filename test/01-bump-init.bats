#!/bin/bash

load test_helper/helper

@test "[Bump] Run any command before init" {
  run git bump version
  assert_failure
  assert_output "Bump is not initialized. Please execute 'git bump init' to start setup."
}

@test "[Bump] Init - clean repo - default values" {
  run git_bump_init
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Init - clean repo - default flag" {
  run git bump init --defaults
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Init - clean repo - custom values" {
  printf "${git_gadget_init_options}customversion\nchange.md\nno\ncustom-tag\nno\n" | run git bump init
  assert_git_bump_config version-file=customversion,changelog-file=change.md,version=0.1.0,recursive=false,tag=custom-tag

}
