#!/bin/bash

load test_helper/helper

setup(){
  [ -d ~/tmp/git-gadgets-test ] || mkdir -p ~/tmp/git-gadgets-test
  cd ~/tmp/git-gadgets-test && rm -rf .git && git init
  [ -f foca ] || touch foca
  [ ! -f .version] || rm -f .version
  [ ! -f CHANGELOG.md ] || rm -f CHANGELOG.md
  git add foca && git commit -m "First commit"
}

@test "[Bump] Run default command before init" {
  run git bump
  assert_failure
  assert_output "Bump is not initialized. Please execute 'git bump init' to start setup."
  #[ "${lines[0]}" = "Bump is not initialized. Please execute 'git bump init' to start setup." ]
}

@test "[Bump] Don't accept to create new version file. " {
  run git bump init <<EOF
n
EOF
  assert_failure
}

@test "[Bump] Init - clean repo - default values" {
  run git_bump_init
  assert_git_bump_config version=0.1.0
}

@test "[Bump] Init - clean repo - custom values" {
  run git bump init <<< $'y\nn\n\ncustom-tag\ny\ncustom-release\ny\ncustom-hotfix'
  assert_git_bump_config version=0.1.0,recursive=false,tag=custom-tag,release=custom-release,hotfix=custom-hotfix

}

@test "[Bump] Init - clean repo - no prefixes" {
  run git bump init <<< $'y\ny\n\n\nn\nn\n'
  assert_git_bump_config version=0.1.0,release=,hotfix=
}
