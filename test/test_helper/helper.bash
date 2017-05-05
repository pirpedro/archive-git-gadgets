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
source "../gadgets/sh-common"

repo_name="git-gadgets-test"
remote_repo_name="${repo_name}-remote"
repo_location=~/tmp/$repo_name
remote_location=~/tmp/$remote_repo_name

init_remote_repo(){
  [ -d "$remote_location" ] || mkdir -p "$remote_location"
  cd "$remote_location" && git init --bare >/dev/null
}

init_empty_repo(){
  local base_dir=$(dirname "$repo_location")
  [ -d "$base_dir" ] || mkdir -p "$base_dir"
  init_remote_repo && {
    cd "$base_dir" && git clone "$remote_location" "$repo_name" >/dev/null 2>&1
    cd "$repo_location" || exit 1
  }
}

init_repo(){
  init_empty_repo
  cd "$repo_location" || exit 1
  [ -f foca ] || touch foca
  git add foca && git commit -m "First commit." >/dev/null
}

assert_git_config_present(){
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
  local master_branch develop_branch
  master_branch="master"
  develop_branch="develop"
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      master=* ) master_branch=${option##master=} ;;
      develop=* ) develop_branch=${option##develop=}
    esac
  done

  echo "branch $master_branch"
  assert_git_config_present core.master $master_branch
  if ! empty $develop_branch; then
    assert_git_config_present core.develop $develop_branch
  fi
}

assert_git_flow_config(){
  local master_branch develop_branch config_path
  master_branch="master"
  develop_branch="develop"
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      master=* ) master_branch=${option##master=} ;;
      develop=* ) develop_branch=${option##develop=}
    esac
  done

  config_path=$(git stats --root-path)/.git/config
  assert git config --get --file $config_path gitflow.branch.master>/dev/null 2>&1
  assert git config --get --file $config_path gitflow.branch.develop>/dev/null 2>&1
  assert_equal "$(git config --get --file $config_path gitflow.branch.master)" "$master_branch"
  assert_equal "$(git config --get --file $config_path gitflow.branch.develop)" "$develop_branch"
}

assert_git_bump_config(){
  local version version_file changelog_file tag
  version_file=".version"; changelog_file="CHANGELOG.md"; tag="v";

  assert_git_gadgets_config
  for option in $(echo "$1" | tr "," "\n"); do
    case "$option" in
      version-file=* ) version_file=${option##version-file=} ;;
      changelog-file=*) changelog_file=${option##changelog-file=} ;;
      version=* ) version=${option##version=}; ;;
      tag=* ) tag=${option##tag=}; ;;
    esac
  done
  assert [ -e $version_file ]
  assert [ -e $changelog_file ] && [ -s $changelog_file ]
  assert_equal "$(cat $version_file)" $version
  run cat $changelog_file
  assert_output --partial "## $version"
  assert_output --partial "## 0.1.0"
  assert_git_config_present bump.path.version $version_file
  assert_git_config_present bump.path.changelog $changelog_file
  assert_git_config_present bump.prefix.tag $tag
}



# Branch master name
git_gadget_init_options="master\nyes\ndevelop\n"

#
# version file path
# Changelog path
# tag prefix
# change changelog file?
#
git_bump_init_options=".version\nCHANGELOG.md\nv\nno\n"

git_bump_init(){
  git bump init --defaults
}
