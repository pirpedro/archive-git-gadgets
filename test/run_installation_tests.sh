#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1


tests=()
for i in ubuntu; do

  #####   TESTING MAKEFILE  ##################
  echo "TESTING MAKEFILE"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #download and use makefile to install
  vagrant ssh "$i" -c "git clone https://github.com/pirpedro/git-gadgets; cd git-gadgets; git checkout develop; git submodule update --init --recursive; sudo make install"
  #run tests
  vagrant ssh "$i" -c "cd git-gadgets/test; bats ."

  #########   TESTING INSTALLATION SCRIPT (STABLE VERSION)   #############
  echo "TESTING INSTALLATION SCRIPT (STABLE VERSION)"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #use installer script to handle everything
  vagrant ssh "$i" -c "cp /vagrant/contrib/installer .; chmod +x installer; sudo ./installer install stable"
  #download repo again to run the tests
  vagrant ssh "$i" -c "git clone https://github.com/pirpedro/git-gadgets; cd git-gadgets; git checkout develop; git submodule update --init --recursive;"
  vagrant ssh "$i" -c "cd git-gadgets/test; bats ."

  #########   TESTING INSTALLATION SCRIPT (DEVELOPMENT VERSION)   #############
  echo "TESTING INSTALLATION SCRIPT (DEVELOPMENT VERSION)"
  vagrant destroy -f "$i" || true
  vagrant up --no-provision "$i"
  #install git and bats
  vagrant ssh "$i" -c "sudo apt-get install git git-core -y; sudo add-apt-repository ppa:duggan/bats --yes; sudo apt-get update -qq; sudo apt-get install -qq bats"
  #use installer script to handle everything
  vagrant ssh "$i" -c "cp /vagrant/contrib/installer .; chmod +x installer; sudo ./installer install develop"
  #download repo again to run the tests
  vagrant ssh "$i" -c "cd git-gadgets/test; bats ."
done
