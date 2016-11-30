#!/bin/bash

source $(git stats --root-path)/bin/sh-common

DIR=$(location $0)


TESTS=$(ls $DIR/test*.sh | grep -v $DIR/test.sh | sed 's/\.sh$//')
local passed
for test in $TESTS; do
  if [ ! empty "${test}.out.correct"]; then
    rm -rf ${test}.out
    bash ${test}.sh &> ${test}.out
    passed=$(diff $test.out $test.out.correct 2>&1)
  else
    bash ${test}.sh
    passed="$?"
  fi

  if check_boolean "${passed}"; then
    note -f "Test $test passed."
  else
    warn -f "Test $test failed. Output in ${test}.out"
  fi
done
