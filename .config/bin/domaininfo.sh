#!/bin/bash
# A sample shell script to print domain ip address hosting information such as
# Location of server, city, ip address owner, country and network range.
# This is useful to track spammers or research purpose.
# -------------------------------------------------------------------------
# Copyright (c) 2006 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Last updated on Mar/05/2010
# -------------------------------------------------------------------------
 
# Get all domains
_dom=$@
 
# Die if no domains are given
[ $# -eq 0 ] && { echo "Usage: $0 domain1.com domain2.com ..."; exit 1; }
for d in $_dom
do
	_ip=$(host $d | grep 'has add' | head -1 | awk '{ print $4}')
	[ "$_ip" == "" ] && { echo "Error: $d is not valid domain or dns error."; continue; }
	echo "Getting information for domain: $d [ $_ip ]..."
	whois "$_ip" | egrep -w 'OrgName:|City:|Country:|OriginAS:|NetRange:'
	echo ""
done

