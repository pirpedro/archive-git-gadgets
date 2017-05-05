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

assert_git_config_empty(){
  local config_path
  config_path=$(git stats --root-path)/.git/gadgets
  ! git config --get --file $config_path bump.track >/dev/null 2>&1 || \
  assert_equal "$(git config --get --file $config_path bump.track)" ""
}

assert_git_config_track(){
  local config_path
  config_path=$(git stats --root-path)/.git/gadgets
  assert_equal "$(git config --get --file $config_path bump.track)" "$1"
}

@test "[Bump track] no files to track." {
  run git bump track && assert_failure
  assert_output "No new files to track."
  assert_git_config_empty
}

@test "[Bump track] not a regular file." {
  not_a_file="path/to/file"
  run git bump track "$not_a_file" && assert_failure
  assert_output "$not_a_file is not a regular file."
  assert_git_config_empty
}

@test "[Bump track] accept file without version number." {
  new_file="test_file"
  run touch "$new_file" && assert_success
  printf 'yes\n' | run git bump track "$new_file"
  assert_success
  assert_git_config_track "$new_file"
}

@test "[Bump track] don't accept file without version number." {
  new_file="test_file"
  run touch "$new_file" && assert_success
  printf 'no\n' | run git bump track "$new_file"
  assert_success
  assert_git_config_empty
}

@test "[Bump track] don't accept file with version number when list all" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  printf 'no\n' | run git bump track
  assert_success && assert_git_config_empty
}

@test "[Bump track] accept file with version number when list all" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  printf 'yes\n' | run git bump track
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] accept file with version number" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  run git bump track "$new_file"
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] accept multiple files" {
  new_file1="test_file"
  new_file2="test_file2"
  echo "0.1.0" > "$new_file1" && git add "$new_file1"
  echo "0.1.0" > "$new_file2" && git add "$new_file2"
  printf "yes\nyes\n" | run git bump track
  assert_success && assert_git_config_track "$new_file1 $new_file2"
}

@test "[Bump track] subfolder file 1" {
  mkdir tmp
  new_file="tmp/test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  printf 'yes\n' | run git bump track
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] subfolder file 2" {
  mkdir tmp
  new_file="tmp/test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  run git bump track $new_file
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] parent folder file 1" {
  mkdir -p tmp/tmp2
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  cd tmp/tmp2
  printf 'yes\n' | run git bump track
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] parent folder file 2" {
  mkdir -p tmp/tmp2
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  cd tmp/tmp2
  run git bump track "../../$new_file"
  assert_success && assert_git_config_track "$new_file"
}

@test "[Bump track] remove without argument" {
  run git bump track -d && assert_failure
  assert_output "No file passed to untrack."
}

@test "[Bump track] remove a no existent file" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  git bump track "$new_file"
  run git bump track -d /path/to/file && assert_success
  assert_output "" && assert_git_config_track "$new_file"
}

@test "[Bump track] remove a no tracked file" {
  new_file1="test_file"
  new_file2="test_file2"
  echo "0.1.0" > "$new_file1" && git add "$new_file1"
  echo "0.1.0" > "$new_file2" && git add "$new_file2"
  git bump track "$new_file1"
  run git bump track -d "$new_file2" && assert_success
  assert_output "" && assert_git_config_track "$new_file1"
}

@test "[Bump track] remove a tracked file" {
  new_file1="test_file"
  new_file2="test_file2"
  echo "0.1.0" > "$new_file1" && git add "$new_file1"
  echo "0.1.0" > "$new_file2" && git add "$new_file2"
  git bump track "$new_file1"
  git bump track "$new_file2"
  run git bump track -d "$new_file1" && assert_success
  assert_output "" && assert_git_config_track "$new_file2"
}

@test "[Bump track] remove last tracked file" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  git bump track "$new_file"
  run git bump track -d "$new_file" && assert_success
  assert_output "" && assert_git_config_empty
}

@test "[Bump track] retrack a file" {
  new_file="test_file"
  echo "0.1.0" > "$new_file" && git add "$new_file"
  git bump track "$new_file"
  run git bump track -d "$new_file" && assert_success
  assert_output "" && assert_git_config_empty
  run git bump track "$new_file" && assert_success
  assert_output "" && assert_git_config_track "$new_file"
}
