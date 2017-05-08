#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1

tests=()
for i in ubuntu; do
  vagrant up "$i"
  command="cd /vagrant/test; bats ."
  vagrant ssh "$i" -c "$command"
done
