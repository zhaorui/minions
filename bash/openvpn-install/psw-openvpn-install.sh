#!/bin/bash
#
# This is a script based on openvpn-install
# https://github.com/Nyr/openvpn-install
#
# Copyright (c) 2019 zhaorui. Released under the MIT License

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi

if [[ ! -e /dev/net/tun ]]; then
	echo "The TUN device is not available
You need to enable TUN before running this script"
	exit
fi

if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	GROUPNAME=nobody
	RCLOCAL='/etc/rc.d/rc.local'
else
	echo "Looks like you aren't running this installer on Debian, Ubuntu or CentOS"
	exit
fi

newclient () {
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

if [[ -e /etc/openvpn/server.conf ]]; then
    clear
    echo "Looks like SD-WAN is already installed."
    echo
    echo "What do you want to do?"
	echo "   1) Add a new user"
    echo "   2) Remove SD-WAN"
    echo "   3) Exit"
    read -p "Select an option [1-3]: " option
		case $option in
			1) 
			echo
			echo "Tell me a name for the client certificate."
			echo "Please, use one word only, no special characters."
			read -p "Client name: " -e CLIENT
			read -p "Password: " -e PASWD
			echo "$CLIENT $PASWD" >> /etc/openvpn/psw-file
			# Generates the custom client.ovpn
			newclient "$CLIENT"
			echo
			echo "Client $CLIENT added, configuration is available at:" ~/"$CLIENT.ovpn"
			exit
			;;
			2) 
			echo
			read -p "Do you really want to remove SD-WAN? [y/N]: " -e REMOVE
			if [[ "$REMOVE" = 'y' || "$REMOVE" = 'Y' ]]; then
				if [[ "$OS" = 'debian' ]]; then
					apt-get remove --purge -y openvpn
				else
					yum remove openvpn -y
				fi
				rm -rf /etc/openvpn
				echo
				echo "OpenVPN removed!"
			else
				echo
				echo "Removal aborted!"
			fi
			exit
			;;
			3) exit;;
		esac
else
    clear
	echo 'Welcome to this SD-WAN installer!'
	echo
	# SD-WAN setup and first user creation
	echo "I need to ask you a few questions before starting the setup."
	echo "You can leave the default options and just press enter if you are ok with them."
	echo
	echo "First, provide the IPv4 address of the network interface you want SD-WAN"
	echo "listening to."

    # Autodetect IP address and pre-fill for the user
	IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
	read -p "IP address: " -e -i $IP IP
	# If $IP is a private IP address, the server must be behind NAT
	if echo "$IP" | grep -qE '^(10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|192\.168)'; then
		echo
		echo "This server is behind NAT. What is the public IPv4 address or hostname?"
		read -p "Public IP address / hostname: " -e PUBLICIP
	fi
	echo

	# Select protocol
	echo "Which protocol do you want for OpenVPN connections?"
	echo "   1) UDP (recommended)"
	echo "   2) TCP"
	read -p "Protocol [1-2]: " -e -i 1 PROTOCOL
	case $PROTOCOL in
		1) 
		PROTOCOL=udp
		;;
		2) 
		PROTOCOL=tcp
		;;
	esac
	echo

	# Select Port
	echo "What port do you want OpenVPN listening to?"
	read -p "Port: " -e -i 1194 PORT
	echo

	# Select DNS
	echo "Which DNS do you want to use with the VPN?"
	echo "   1) Current system resolvers"
	echo "   2) 1.1.1.1"
	echo "   3) Google"
	echo "   4) OpenDNS"
	echo "   5) Verisign"
	read -p "DNS [1-5]: " -e -i 1 DNS
	echo

	# Select client name which is the name of generated ovpn file
	echo "Finally, tell me your name for the client certificate."
	echo "Please, use one word only, no special characters."
	read -p "Client name: " -e -i client CLIENT
	echo

	# Continue
	echo "Okay, that was all I needed. We are ready to set up your OpenVPN server now."
	read -n1 -r -p "Press any key to continue..."

	# prepare necesary binary
	if [[ "$OS" = 'debian' ]]; then
		apt-get update
		apt-get install openvpn iptables openssl ca-certificates -y
	else
		# Else, the distro is CentOS
		yum install epel-release -y
		yum install openvpn iptables openssl ca-certificates -y
	fi

	# Get easy-rsa, install it to /etc/openvpn/easy-rsa
	EASYRSAURL='https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz'
	wget -O ~/easyrsa.tgz "$EASYRSAURL" 2>/dev/null || curl -Lo ~/easyrsa.tgz "$EASYRSAURL"
	tar xzf ~/easyrsa.tgz -C ~/
	mv ~/EasyRSA-v3.0.6/ /etc/openvpn/
	mv /etc/openvpn/EasyRSA-v3.0.6/ /etc/openvpn/easy-rsa/
	chown -R root:root /etc/openvpn/easy-rsa/
	rm -f ~/easyrsa.tgz
	
	# Create the PKI, set up the CA and the server and client certificates
	cd /etc/openvpn/easy-rsa/
	./easyrsa init-pki
	./easyrsa build-ca nopass
	EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
	EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

	# Move the stuff we need
	cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn

	# CRL is read with each client connection, when OpenVPN is dropped to nobody
	chown nobody:$GROUPNAME /etc/openvpn/crl.pe

	# Generate key for tls-auth also called static key
	openvpn --genkey --secret /etc/openvpn/ta.key

	# Create the DH parameters file using the predefined ffdhe2048 group
	echo '-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----' > /etc/openvpn/dh.pem

	# Generate checkpsw.sh 
	curl -Lo /etc/openvpn/checkpsw.sh "https://gist.githubusercontent.com/zhaorui/800c962db30a48d6c158eb04808c2e46/raw/9a8a6aa830f0008f5cf67323d8c5a9c63df1c149/checkpsw.sh"
	echo "client password" > /etc/openvpn/psw-file

	# Generate server.conf
	echo "port $PORT
proto $PROTOCOL
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
#auth SHA512
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" > /etc/openvpn/server.conf

# Uncomment below would change default gw of client to be tunnel, very hardcore!
# echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server.conf

	# DNS
	case $DNS in
		1)
		# Locate the proper resolv.conf
		# Needed for systems running systemd-resolved
		if grep -q "127.0.0.53" "/etc/resolv.conf"; then
			RESOLVCONF='/run/systemd/resolve/resolv.conf'
		else
			RESOLVCONF='/etc/resolv.conf'
		fi
		# Obtain the resolvers from resolv.conf and use them for OpenVPN
		grep -v '#' $RESOLVCONF | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2)
		echo 'push "dhcp-option DNS 1.1.1.1"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 1.0.0.1"' >> /etc/openvpn/server.conf
		;;
		3)
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
		4)
		echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
		;;
		5)
		echo 'push "dhcp-option DNS 64.6.64.6"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 64.6.65.6"' >> /etc/openvpn/server.conf
		;;
	esac

	echo "keepalive 10 120
cipher AES-256-CBC
user nobody
group $GROUPNAME
persist-key
persist-tun
status sdwan-status.log 30
verb 3
script-security 3
auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env
verify-client-cert none
username-as-common-name
crl-verify crl.pem" >> /etc/openvpn/server.conf

	# And finally, restart OpenVPN
	if [[ "$OS" = 'debian' ]]; then
		# Little hack to check for systemd
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
		else
			/etc/init.d/openvpn restart
		fi
	else
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
			systemctl enable openvpn@server.service
		else
			service openvpn restart
			chkconfig openvpn on
		fi
	fi

	# client-common.txt is created so we have a template to add further users later
	echo "client
dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
remote $IP $PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
setenv opt block-outside-dns
key-direction 1
verb 3" > /etc/openvpn/client-common.txt

	# Generates the custom client.ovpn
	newclient "$CLIENT"
	echo
	echo "Finished!"
	echo
	echo "Your client configuration is available at:" ~/"$CLIENT.ovpn"
	echo "If you want to add more clients, you simply need to run this script again!"	
fi

