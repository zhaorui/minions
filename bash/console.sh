#!/bin/bash

ALILANG_LOG_PATH=$(ls -t ~/Library/Logs/AliLangClient/ | tr '\t' '\n' | head -n 1)
ALILANG_LOG_PATH="${HOME}/Library/Logs/AliLangClient/"$ALILANG_LOG_PATH

HEMA_LOG_PATH=$(ls -t ~/Library/Logs/HemaClient/ | tr '\t' '\n' | head -n 1)
HEMA_LOG_PATH="${HOME}/Library/Logs/HemaClient/"$HEMA_LOG_PATH


function console {
    case $1 in
    hema) open -a /Applications/Utilities/Console.app "$HEMA_LOG_PATH" ;;
    alilang) open -a /Applications/Utilities/Console.app "$ALILANG_LOG_PATH" ;;
    *) open /Applications/Utilities/Console.app
    esac
}

console $1
