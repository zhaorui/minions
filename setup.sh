#!/bin/bash
set -e

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