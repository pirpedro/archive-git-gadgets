#!/bin/bash

# Load a library from the `${BATS_TEST_DIRNAME}/test_helper' directory.
#
# Globals:
#   none
# Arguments:
#   $1 - name of library to load
# Returns:
#   0 - on success
#   1 - otherwise
load_lib() {
  local name="$1"
  load "test_helper/${name}/load"
}

load_lib bats-support
load_lib bats-assert

assert_empty(){
  if [[ -n $1 ]]; then
      batslib_print_kv_single 5 'Value' "$1" \
      | batslib_decorate 'value not empty' \
      | fail
  fi
}

assert_not_empty(){
  if [[ ! -n "$1" ]]; then
      batslib_print_kv_single 8 'Variable' "empty" \
      | batslib_decorate 'value is empty' \
      | fail
  fi
}

assert_git_config_present(){
  assert_not_empty "$1"
  assert_not_empty "$2"
  if ! git config --get gadgets."$1">/dev/null 2>&1 ||
  [ $(git config --get gadgets."$1") != "$2" ]; then
    batslib_print_kv_single_or_multi 8 \
        'expected' "$2" \
        'actual'   "$(git config --get gadgets."$1" 2>&1)" \
      | batslib_decorate 'config values do not equal' \
      | fail
  fi
}

assert_git_config_not_present(){
  assert_not_empty "$1"
  if git config --get gadgets."$1">/dev/null 2>&1 &&
  [ $(git config --get gadgets."$1") != "" ]; then
    batslib_print_kv_single 5 'Value' "$(git config --get gadgets."$1" 2>&1)" \
    | batslib_decorate 'git config not empty' \
    | fail
  fi
}

assert_git_gadgets_config(){
  local master_branch
  master_branch="master"
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      master=* ) master_branch=${option##master=}; ;;
    esac
  done

  assert_git_config_present core.master $master_branch
}

assert_git_bump_config(){
  local version recursive tag release hotfix
  recursive=true; tag="v"; release="release/"; hotfix="hotfix/"

  assert_git_gadgets_config
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      version=* ) version=${option##version=}; ;;
      recursive=* ) recursive=${option##recursive=}; ;;
      tag=* ) tag=${option##tag=}; ;;
      release=* ) release=${option##release=}; ;;
      hotfix=* ) hotfix=${option##hotfix=}; ;;
    esac
  done
  assert [ -e .version ]
  assert [ -e CHANGELOG.md && -s CHANGELOG.md ]
  assert_equal $(cat .version) $version
  if [ "$recursive" == true ]; then
    assert_git_config_present branch.master.recursive $recursive
  else
    assert_git_config_present branch.master.recursive false
  fi
  assert_git_config_present branch.master.version $version
  assert_git_config_present bump.prefix.tag $tag
  if [ -n "$release" ]; then
    assert_git_config_present bump.prefix.release $release
  else
    assert_git_config_not_present bump.prefix.release
  fi

  if [ -n "$hotfix" ]; then
    assert_git_config_present bump.prefix.hotfix $hotfix
  else
    assert_git_config_not_present bump.prefix.hotfix
  fi
}

git_bump_init(){
  git bump init <<EOF

y # create new .version file
y # recursively replace
\n #change changelog.md

y # use release branch

y # use hotfix branch

EOF
}
