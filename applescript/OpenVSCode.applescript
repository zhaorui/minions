# Code is inspired from https://stackoverflow.com/questions/12129989/getting-finders-current-directory-in-applescript-stored-as-application
tell application "Finder" to set currentDir to (target of front Finder window) as text
do shell script "open -a '/Applications/Visual Studio Code.app' " & quoted form of POSIX path of currentDir