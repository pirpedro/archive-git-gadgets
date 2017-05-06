# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.provision "bats-installation",
  type: "shell",
  inline:<<SCRIPT
    sudo add-apt-repository ppa:duggan/bats --yes
    sudo apt-get update -qq
    sudo apt-get install -qq bats
SCRIPT

  config.vm.provision "git-installation",
  type: "shell",
  inline:<<SCRIPT
    sudo apt-get install git git-core -y
SCRIPT

  config.vm.provision "git-gadgets configuration",
  type: "shell",
  inline:<<SCRIPT
    sudo ln -sfF /vagrant/bin/* /usr/local/bin/
    sudo ln -sfF /vagrant/gadgets /usr/local/gadgets
SCRIPT

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-16.04"
    ubuntu.vm.hostname = "peterparker"
    ubuntu.vm.provider :virtualbox do |provider|
      provider.name = "my-config-ubuntu"
    end
  end


end
