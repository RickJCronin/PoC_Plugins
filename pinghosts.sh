#!/bin/sh
#
# getping.sh - ping servers and produce a html report. Unix/Linux. 
#
# 24-Jul-2004	ver 1.10
#
# USAGE: getping.sh > website.html		# eg, triggered by crontab
#


#
# --- Config Variables ---
#

# hostlist - hosts to ping, eg hostlist="venus earth mars"
#
hostlist=""

# hostfile - text file which is a list of hosts to ping, eg hostfile="prod.txt"
#
hostfile="/Users/croninr/Documents/hosts.txt"

ping=/sbin/ping	# Location of ping
hostsdb=/etc/hosts	# System hosts file, default hosts to ping
timeout=5		# Default ping timeout, seconds
PATH=/bin:$PATH

#
# --- Check ping exists ---
#
if [ ! -x $ping ]
then
	ping=/bin/ping
	if [ ! -x $ping ]; then
		echo >&2 "ERROR1: Can't find ping."
		exit 1
	fi
fi

#
# --- Fetch hosts to ping ---
#
if [ "$hostfile" != "" ]; then
	if [ ! -r $hostfile ]; then
	   echo >&2 "ERROR2: $hostfile, is not readable."
	   exit 2
	fi
	hosts=`cat $hostfile` 		# Use hostfile for list of hosts
fi

if [ "$hostlist" != "" ]; then		# hostlist gets preference
	hosts="$hostlist"		# ("if" is easier to follow than
fi					#  Bourne parameter substitution)

if [ "$hosts" = "" ]; then		# if unset, fetch hosts from default
	if [ ! -r "$hostsdb" ]; then
		echo >&2 "ERROR3: $hostsdb, is not readable."
		exit 2
	fi
	hosts=`awk '/^[0-9]/ { print $1 }' $hostsdb`
fi

for host in $hosts
do
	echo "Pinging $host"
	Out=$($ping $host -q -c 1 -t $timeout)
	Out=${Out// /,}
	Percent="$(cut -d',' -f18 <<<$Out)"
	RoundTrip="$(cut -d'/' -f5 <<<$Out)"
	echo "ping output = $Out"
	echo "percent loss = $Percent"
	echo "Roundtrip = $RoundTrip"
	if [ $Percent = "0.0%" ]; then
	  echo "RjC.TestPing.HostUp 1 source=Region1 Target=$host" | nc -w 1 192.168.43.150 2878
	  echo "RjC.TestPing.HostResponse $RoundTrip source=Region1 Target=$host" | nc -w 1 192.168.43.150 2878
	else
	  echo "RjC.TestPing.HostDown 0 source=Region1 Target=$host" | nc -w 1 192.168.43.150 2878
	fi
done 





