#!/bin/bash
###
#
# Check Neutron Service
# Author: HoangDH - daohuyhoang87@gmail.com
# Release: 23/8/2017 - 3:28PM
#
###

check_on_other_node() {
source ~/keystonerc_admin
neutron agent-list >> /tmp/info_neutron.h2
services=`cat /tmp/info_neutron.h2 | grep -w "xxx" | awk  '{ print $8 }' FS="|" | sort -u`

for service in $services
	do
		node=`cat /tmp/info_neutron.h2 | grep -w "$service" | awk  '{ print $4 }' FS="|" | sort -u`
		echo -e "$node:\t$service" >> /tmp/err_neutron.h2
	done

}



i=0
f=$(systemctl status neutron-server | grep 'active (running)')
if [ -z "$f" ]
	then
		i=0
	else
		check_on_other_node
		for service in neutron-openvswitch-agent neutron-metadata-agent neutron-dhcp-agent neutron-l3-agent
		do 
			flag=$(systemctl status $service | grep 'active (running)')
			if [ -n "$flag" ]
			then
				i=$(expr $i + 1)
			fi
		done 
fi

rm -rf /tmp/info_neutron.h2

case $i in
	4)
		echo "OK. Neutron-server is running."
		exit 0
		;;
	[1-3]*)
		s=`cat /tmp/err_neutron.h2` 
		rm -rf /tmp/err_neutron.h2
		echo -e "WARNING. Neutron-agent is/are not running.\n$s"
		exit 1
		;;	
	0) 
		echo "CIRTICAL. Neutron-server doesn't running."
		exit 2
		;;
	*)
		echo "UNKNOWN. Neutron-server or agent don't running."
		exit 3
		;;	
esac

	