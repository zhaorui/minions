#!/bin/bash
set -e

BASH_TOOL_INSTALL_PATH=/usr/local/bin
MINION_PROJ_PATH=$(cd `dirname $0`; pwd)
PROJGEN_PATH=${MINION_PROJ_PATH}/bash/projgen/projgen.sh

echo "MINION_PROJ_PATH=${MINION_PROJ_PATH}"

if [ ! -e "${BASH_TOOL_INSTALL_PATH}/console" ]; then
    ln -s "${MINION_PROJ_PATH}/bash/console.sh" "${BASH_TOOL_INSTALL_PATH}/console" 
fi

if [ ! -e "${BASH_TOOL_INSTALL_PATH}/git-taginfo" ]; then
    ln -s "${MINION_PROJ_PATH}/bash/git-taginfo.sh" "${BASH_TOOL_INSTALL_PATH}/git-taginfo" 
fi

if [ ! -e "${BASH_TOOL_INSTALL_PATH}/git-open" ]; then
    ln -s "${MINION_PROJ_PATH}/bash/git-open/git-open" "${BASH_TOOL_INSTALL_PATH}/git-open" 
fi

if [ ! -e "${BASH_TOOL_INSTALL_PATH}/git-goto" ]; then
    ln -s "${MINION_PROJ_PATH}/bash/git-goto.sh" "${BASH_TOOL_INSTALL_PATH}/git-goto" 
fi

# TODO: check default shell of current user then add alias to shell boot script;
# also add PATH environment according to default shell

# Install homebrew if not found
if ! command -v brew > /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! command -v pod > /dev/null; then
    sudo gem install cocoapods
fi

if ! brew cask list | grep -i hammerspoon > /dev/null; then
    if ! [ -d /Applications/Hammerspoon.app ] ; then 
        echo "Hammerspoon is not installed, install it now..."
        brew cask install hammerspoon
    fi
fi

if ! [ -d ~/.hammerspoon ]; then
    echo "~/.hammerspoon not exist, create it first"
    mkdir ~/.hammerspoon
fi

cp -a lua/HammerSpoon ~/.hammerspoon

# Install tools from objc
xcodebuild clean build -project objc/class-dump/class-dump.xcodeproj
cp -a objc/class-dump/build/Release/class-dump /usr/local/bin/class-dump

xcodebuild clean build -project objc/lsapp/lsapp.xcodeproj
cp -a objc/lsapp/build/Release/lsapp /usr/local/bin/lsapp