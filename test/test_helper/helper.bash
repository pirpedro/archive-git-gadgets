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

setup(){
  if [ -d ~/tmp/git-gadgets-test ]; then
  find ~/tmp/git-gadgets-test -mindepth 1 -delete
  else
    mkdir -p ~/tmp/git-gadgets-test
  fi
  cd ~/tmp/git-gadgets-test && git init
  touch ~/tmp/focona
  [ -f foca ] || touch foca
  git add foca && git commit -m "First commit"
}

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
  local config_path
  config_path=$(git stats --root-path)/.git/gadgets
  if ! git config --get --file $config_path "$1">/dev/null 2>&1 ||
  [ $(git config --get --file $config_path "$1") != "$2" ]; then
    batslib_print_kv_single_or_multi 8 \
        'expected' "$2" \
        'actual'   "$(git config --get --file $config_path "$1" 2>&1)" \
      | batslib_decorate 'config values do not equal' \
      | fail
  fi
}

assert_git_config_not_present(){
  assert_not_empty "$1"
  local config_path
  config_path=$(git stats --root-path)/.git/gadgets
  if git config --get --file $config_path "$1">/dev/null 2>&1 &&
  [ $(git config --get  --file $config_path "$1") != "" ]; then
    batslib_print_kv_single 5 'Value' "$(git config --get --file $config_path "$1" 2>&1)" \
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
  local version version_file changelog_file recursive tag
  version_file=".version"; changelog_file="CHANGELOG.md"; recursive=true; tag="v";

  assert_git_gadgets_config
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      version-file=* ) version_file=${option##version-file=} ;;
      changelog-file=*) changelog_file=${option##changelog-file=} ;;
      version=* ) version=${option##version=}; ;;
      recursive=* ) recursive=${option##recursive=}; ;;
      tag=* ) tag=${option##tag=}; ;;
    esac
  done
  assert [ -e $version_file ]
  assert [ -e $changelog_file && -s $changelog_file ]
  assert_equal $(cat $version_file) $version
  assert_git_config_present bump.path.version $version_file
  assert_git_config_present bump.path.changelog $changelog_file
  if [ "$recursive" == true ]; then
    assert_git_config_present bump.recursive $recursive
  else
    assert_git_config_present bump.recursive false
  fi
  assert_git_config_present bump.prefix.tag $tag
}

assert_git_flow_config(){
  local develop_branch feature_prefix release_prefix hotfix_prefix bump
  develop_branch="develop"; feature_prefix="feature/"; release_prefix="release/"
  hotfix_prefix="hotfix/"; bump=1;

  assert_git_gadgets_config
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      develop=* ) develop_branch=${option##develop=} ;;
      feature=*) feature_prefix=${option##feature=} ;;
      release=*) release_prefix=${option##release=} ;;
      hotfix=*) hotfix_prefix=${option##hotfix=} ;;
      bump=* ) bump=${option##bump=} ;;
    esac
  done

  assert_git_config_present flow.branch.develop $develop_branch
  assert_git_config_present flow.prefix.feature $feature_prefix
  assert_git_config_present flow.prefix.release $release_prefix
  assert_git_config_present flow.prefix.hotfix $hotfix_prefix
  if [ bump -eq 0 ]; then
    assert_git_bump_config
  fi

}

# Branch master name
git_gadget_init_options="master\n"

#
# version file path
# Changelog path
# recursive?
# tag prefix
# change changelog file?
#
git_bump_init_options=".version\nCHANGELOG.md\nyes\nv\nno\n"

#
# Branch develop name
# Use feature?
# Feature prefix
# Use release?
# Release prefix
# Use hotfix?
# Hotfix prefix
# Configure git bump?
#
git_flow_init_options="develop\nyes\n\nyes\n\nyes\n\nno\n"


git_bump_init(){
  git bump init --defaults
}

git_flow_init(){
  git flow init --defaults
}
