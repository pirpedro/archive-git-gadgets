#!/bin/bash

load test_helper/helper

@test "[Gadgets] Init empty folder" {
  rm -rf .git
  run git gadgets init <<< $'master\nno\nno\n'
  assert_git_gadgets_config
}

@test "[Gadgets] Init empty repository" {
  run git gadgets init <<< $'master\nno\nno\n'
  assert_git_gadgets_config
}

@test "[Gadgets] Try to init an already configured repo" {
  git gadgets init <<< $'master\nno\nno\n'
  run git gadgets init
  assert_failure
}

@test "[Gadgets] Init and accept configure git flow" {
  run printf "master\nyes\n$git_flow_init_options" | git gadgets init
  assert_git_flow_config
}

@test "[Gadgets] Init and accept configure git bump" {
  run printf "master\nno\nyes\n$git_bump_init_options" | git gadgets init
  assert_git_bump_config version=0.1.0
}

@test "[Gadgets] Init and accept configure all" {
  printf "master\nyes\ndevelop\nyes\n\nyes\n\nyes\n\nyes\n$git_bump_init_options" | git gadgets init
  assert_git_flow_config bump=0
}
