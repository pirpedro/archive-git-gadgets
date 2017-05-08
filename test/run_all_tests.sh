#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1

source run_installation_tests.sh
source run_core_tests.sh
