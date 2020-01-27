ssh -i "RjC-keypair.pem" ubuntu@ec2-34-244-6-47.eu-west-1.compute.amazonaws.com##!/bin/bash
. /etc/telegraf/proxy.conf
Proxy=$Proxy
Port=$Port
IPadd=$(hostname -I)
IPadd=`echo $IPadd | sed -e 's/^[[:space:]]*//'`
Host="$(hostname)"
##############################################################################
# Get the OS Version
###############################################################################
if [ -f /etc/os-release ]; then
    #echo "freedesktop.org and systemd"
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_I
    NC="nc"
elif type lsb_release >/dev/null 2>&1; then
    #echo "2"
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
    NC="ncat"
elif [ -f /etc/lsb-release ]; then
    #echo "UBUNTU1"
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
    NumSvcs=$(service --status-all | wc -l)
    NC="ncat"
    # echo "RjC.Host.Details.NumServices $NumSvcs source=$Host" | timeout 1 ncat localhost 2878
elif [ -f /etc/debian_version ]; then
    3echo "Older Debian/Ubuntu/etc."
    #echo "UBUNTU2"
    OS=Debian
    VER=$(cat /etc/debian_version)
    NC="ncat"
elif [ -f /etc/SuSe-release ]; then
    #echo "5"
    # Older SuSE/etc.
    #echo "Older SUSE"
    NC="ncat"
elif [ -f /etc/redhat-release ]; then
    #echo "6"
    # Older Red Hat, CentOS, etc.
    #echo "Older RedHat, CentOS or Generic"
    OS=$(uname -s)
    VER=$(uname -r)
    NC="ncat"
else
    #echo "bottom"
    #echo "Fall back to uname, e.g. "Linux <version>", also works for BSD, etc."
    OS=$(uname -s)
    VER=$(uname -r)
    NC="ncat"
fi
if [ -z "$VER" ]; then
        #echo "variable is empty"
        VER=$(uname -r)
fi
echo "Linux.Host.Details.Count 1 source=$Host IPaddress=$IPadd  OS=$OS  Version=$VER Hostname=$Host"| timeout 1 $NC $Proxy $Port