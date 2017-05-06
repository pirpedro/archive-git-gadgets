#!/usr/bin/env bash
load test_helper/helper

setup(){
  [ ! -d "$repo_location" ] || rm -rf "$repo_location"
  [ ! -d "$remote_location" ] || rm -rf "$remote_location"
  init_repo
  git_bump_init
}

teardown(){
  [ ! -d "$repo_location" ] || rm -rf "$repo_location"
  [ ! -d "$remote_location" ] || rm -rf "$remote_location"
}

@test "[Bump] without initialization" {
  rm -rf .git
  run git bump && assert_failure
  assert_output "Bump is not initialized. Please execute 'git bump init' to start setup."
}

@test "[Bump] default increment" {
  run git bump
  assert_git_bump_config version=0.2.0
}

@test "[Bump] major version" {
  run git bump major
  assert_git_bump_config version=1.0.0
}

@test "[Bump] patch version" {
  run git bump patch
  assert_git_bump_config version=0.1.1
}

@test "[Bump] print current version" {
  run git bump -v && assert_success
  assert_output "0.1.0"
  run git bump && assert_success
  run git bump -v && assert_success
  assert_output "0.2.0"
}

@test "[Bump] to a specific version" {
  run git bump --version=2.7.0
  assert_git_bump_config version=2.7.0
}

@test "[Bump] keep untracked files immutable" {
  file="new_file"
  git bump
  echo "0.2.0" > "$file" && git add "$file"
  run git bump && assert_success
  assert_git_bump_config version=0.3.0
  run cat "$file" && assert_output "0.2.0"
}

@test "[Bump] change tracked file" {
  file="new_file"
  git bump
  echo "0.2.0" > "$file" && git add "$file"
  git bump track "$file"
  run git bump && assert_success
  assert_git_bump_config version=0.3.0
  run cat "$file" && assert_output "0.3.0"
}

@test "[Bump] change tracked file in parent folder" {
  file="new_file"
  git bump
  echo "0.2.0" > "$file" && git add "$file"
  git bump track "$file"
  mkdir -p tmp/tmp2 && cd tmp/tmp2
  run git bump && assert_success
  cd ../..
  assert_git_bump_config version=0.3.0
  run cat "$file" && assert_output "0.3.0"
}

@test "[Bump] change multiple tracked file" {
  git bump
  file1="new_file"
  file2="tmp/tmp2/new_file2"
  mkdir -p "tmp/tmp2"
  echo "0.2.0" > "$file1" && git add "$file1"
  git bump track "$file1"
  echo "0.2.0" > "$file2" && git add "$file2"
  git bump track "$file2"
  run git bump && assert_success
  assert_git_bump_config version=0.3.0
  run cat "$file1" && assert_output "0.3.0"
  run cat "$file2" && assert_output "0.3.0"
}

@test "[Bump] try to go back to a previously version" {
  git bump major
  run git bump --version=0.1.0 && assert_failure
  assert_output "New version is not above current version. Use 'git bump revert-to' instead."
}

@test "[Bump] try to go back to a not existent version" {
  git bump major
  run git bump --version=0.7.0 && assert_failure
  assert_output "New version is not above current version. Use 'git bump revert-to' instead."
}
