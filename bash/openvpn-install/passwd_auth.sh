#!/bin/bash

echo "auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env
username-as-common-name
script-security 3 " >> /etc/openvpn/server.conf

cp ./checkpsw.sh /etc/openvpn/checkpsw.sh

chmod 755 /etc/openvpn/checkpsw.sh

touch /etc/openvpn/psw-file
echo "user1 pass1
user2 pass2" >> /etc/openvpn/psw-file

chmod 444 /etc/openvpn/psw-file

touch /etc/openvpn/openvpn-password.log
chmod 666 /etc/openvpn/openvpn-password.log

# restart openvpn
if pgrep systemd-journal; then
    systemctl restart openvpn@server.service
    systemctl enable openvpn@server.service
else
    service openvpn restart
    chkconfig openvpn on
fi