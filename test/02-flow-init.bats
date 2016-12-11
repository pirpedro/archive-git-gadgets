#!/bin/bash

load test_helper/helper

@test "[Flow] Run any command before init" {
  run git flow feature start
  assert_failure
  assert_output "Flow is not initialized. Please execute 'git flow init' to start setup."
}

@test "[Flow] Init empty folder" {
  rm -rf .git
  run git_flow_init
  assert_git_flow_config
}

@test "[Flow] Init - clean repo - default values" {
  run git_flow_init
  assert_git_flow_config
}

@test "[Flow] Try to init again" {
  git_flow_init
  run git flow init
  assert_failure
}

@test "[Flow] Init - clean repo - default flag" {
  run git flow init --defaults
  assert_git_flow_config bump=0
}

@test "[Flow] Init - clean repo - custom values" {
  printf "${git_gadget_init_options}integration\nyes\nfeaturex\nyes\nreleasex\nyes\nhotfixx\nno\n" | run git flow init
  assert_git_flow_config develop=integration,feature=featurex,release=releasex,hotfix=hotfixx
}

@test "[Flow] Init - use argument force" {
  git_flow_init
  printf "integration\nyes\nfeaturex\nyes\nreleasex\nyes\nhotfixx\nno\n" | run git flow init -f
  assert_git_flow_config develop=integration,feature=featurex,release=releasex,hotfix=hotfixx
}
