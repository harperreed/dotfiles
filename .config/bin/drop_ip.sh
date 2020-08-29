#!/bin/sh
/usr/bin/curl --silent http://checkip.dyndns.org > ~/Dropbox/Backups/security/ip_checkins/`hostname`.ip_`date '+%s'`.html
