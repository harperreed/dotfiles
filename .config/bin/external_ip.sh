#!/bin/sh
# ABOUTME: Displays the external/public IP address of this machine.
# ABOUTME: Fetches IP from checkip.dyndns.org via curl.

echo "External :" $(curl --silent https://checkip.dyndns.org | awk '{print $6}' | cut -f 1 -d "<")
