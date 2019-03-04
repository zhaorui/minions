#!/bin/bash
set -e

MINION_PROJ_PATH=$(dirname $0)
PROJGEN_PATH=${MINION_PROJ_PATH}/bash/projgen/projgen.sh

# TODO: check default shell of current user then add alias to shell boot script;

# Install homebrew if not found
if ! command -v brew > /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! command -v pod > /dev/null; then
    sudo gem install cocoapods
fi

if ! brew cask list | grep -i hammerspoon > /dev/null; then
    echo "Hammerspoon is not installed, install it now..."
    brew cask install hammerspoon
fi

if ! [ -d ~/.hammerspoon ]; then
    echo "~/.hammerspoon not exist, create it first"
    mkdir ~/.hammerspoon
fi

cp lua/HammerSpoon/* ~/.hammerspoon