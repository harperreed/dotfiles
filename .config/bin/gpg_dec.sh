#!/bin/sh

if [ -z "$1" ]; then 
  echo "ERROR: File to dec required."; 
  echo "USAGE: gpg_dec.sh doc.txt.asc"
else 
  /usr/local/bin/gpg -d $1 >$1.txt
  

fi
