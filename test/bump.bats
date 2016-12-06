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

@test "[Bump]" {
  
}
