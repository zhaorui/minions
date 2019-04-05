#!/bin/bash

args=($@)
cmd=${args[0]}

case $cmd in
list)
    ls /usr/local/bin | grep nopasswd- ; exit 0;;
*)
    echo "command is unknown"; exit 1;;
esac

read -p "Server name: " -e SERV_NAME
read -p "IP: " -e IP
read -p "Password: " -e PASSWORD

NOPASS_SCRIPT="nopasswd-$SERV_NAME"

echo "#!/usr/bin/expect
spawn ssh root@$IP
expect \"password\"
send  \"${PASSWORD}\r\"
interact" >> $NOPASS_SCRIPT

chmod +x $NOPASS_SCRIPT
mv $NOPASS_SCRIPT /usr/local/bin
