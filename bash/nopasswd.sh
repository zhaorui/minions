#!/bin/bash

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
