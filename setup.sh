#!/bin/bash
set -e

MINION_PROJ_PATH=$(dirname $0)
PROJGEN_PATH=${MINION_PROJ_PATH}/bash/projgen/projgen.sh

# TODO: check default shell of current user then add alias to shell boot script;

# Install homebrew if not found
if ! command -v brew ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! command  -v xcodegen; then
    brew install xcodegen
fi

if ! command -v pod; then
    sudo gem install cocoapods
fi