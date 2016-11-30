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

@test "[Bump] Init flow in an empty repo" {
  run git bump init <<EOF
y # create new .version file
y # recursively replace
\n #change changelog.md

y # use release branch
foca
y # use hotfix branch
foquinha
EOF
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
