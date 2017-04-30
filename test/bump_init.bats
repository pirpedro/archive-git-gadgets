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

@test "[Bump] Run any command before init" {
  init_empty_repo
  run git bump version
  assert_failure
  assert_output "Bump is not initialized. Please execute 'git bump init' to start setup."
}

@test "[Bump] Init empty folder" {
  init_empty_repo
  rm -rf .git
  run git_bump_init
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Init - clean repo - default values" {
  init_empty_repo
  run git_bump_init
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Try to init again" {
  init_empty_repo
  git_bump_init
  run git bump init
  assert_failure
}

@test "[Bump] Init - clean repo - default flag" {
  init_empty_repo
  run git bump init --defaults
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Init - clean repo - custom values" {
  init_empty_repo
  printf "${git_gadget_init_options}customversion\nchange.md\nno\ncustom-tag\nno\n" | run git bump init
  assert_git_bump_config version-file=customversion,changelog-file=change.md,version=0.1.0,recursive=false,tag=custom-tag
}

@test "[Bump] Init - use argument force" {
  init_empty_repo
  git_bump_init
  printf "customversion\nchange.md\nno\ncustom-tag\nno\n" | run git bump init -f
  assert_git_bump_config version-file=customversion,changelog-file=change.md,version=0.1.0,recursive=false,tag=custom-tag
}

#@test "[Bump] Init - a previously configured repository" {
#  git_bump_init
#  rm -rf .git
#
#}
