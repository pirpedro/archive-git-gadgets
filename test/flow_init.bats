#!/bin/bash

load test_helper/helper

setup(){
  [ ! -d "$repo_location" ] || rm -rf "$repo_location"
  [ ! -d "$remote_location" ] || rm -rf "$remote_location"
}

teardown(){
  [ ! -d "$repo_location" ] || rm -rf "$repo_location"
  [ ! -d "$remote_location" ] || rm -rf "$remote_location"
}

@test "[Flow] Run any command before init" {
  init_empty_repo
  run git flow feature start
  assert_failure
  assert_output "Flow is not initialized. Please execute 'git flow init' to start setup."
}

@test "[Flow] Init empty folder" {
  init_empty_repo
  rm -rf .git
  run git_flow_init
  assert_git_flow_config
}

@test "[Flow] Init - clean repo - default values" {
  init_empty_repo
  run git_flow_init
  assert_git_flow_config
}

@test "[Flow] Try to init again" {
  init_empty_repo
  git_flow_init
  run git flow init
  assert_failure
}

@test "[Flow] Init - clean repo - default flag" {
  init_empty_repo
  run git flow init --defaults
  assert_git_flow_config bump=0
}

@test "[Flow] Init - clean repo - custom values" {
  init_empty_repo
  printf "${git_gadget_init_options}integration\nyes\nfeaturex\nyes\nreleasex\nyes\nhotfixx\nno\n" | run git flow init
  assert_git_flow_config develop=integration,feature=featurex,release=releasex,hotfix=hotfixx
}

@test "[Flow] Init - use argument force" {
  init_empty_repo
  git_flow_init
  printf "integration\nyes\nfeaturex\nyes\nreleasex\nyes\nhotfixx\nno\n" | run git flow init -f
  assert_git_flow_config develop=integration,feature=featurex,release=releasex,hotfix=hotfixx
}
