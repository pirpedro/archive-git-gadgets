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


@test "[Gadgets] Init empty folder" {
  init_empty_repo
  rm -rf .git
  run git gadgets init <<< $'master\nno\nno\nno\n'
  assert_git_gadgets_config develop=
}

@test "[Gadgets] Init empty repository" {
  init_empty_repo
  run git gadgets init <<< $'master\nno\nno\nno\n'
  assert_git_gadgets_config develop=
}

@test "[Gadgets] Try to init an already configured repo" {
  init_repo
  git gadgets init <<< $'master\nno\nno\nno\n'
  run git gadgets init
  assert_failure
}

@test "[Gadgets] Init and accept configure only git flow" {
  init_repo
  printf "${git_gadget_init_options}no\nyes\n" | run git gadgets init
  assert_git_flow_config
}

@test "[Gadgets] Init and accept configure only git bump" {
  init_repo
  printf "${git_gadget_init_options}yes\n${git_bump_init_options}no\n" | run git gadgets init
  assert_git_bump_config version=0.1.0
}

@test "[Gadgets] Init and accept configure all" {
  init_repo
  printf "${git_gadget_init_options}yes\n${git_bump_init_options}yes\n" | run git gadgets init
  assert_git_flow_config
}


@test "[Gadgets] Init custom values" {
  local master="othermaster" develop="newdev"
  init_repo
  printf "$master\nyes\n$develop\nyes\n${git_bump_init_options}yes\n" | run git gadgets init
  assert_git_gadgets_config master=$master,develop=$develop
  assert_git_flow_config master=$master,develop=$develop
}
