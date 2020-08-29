#!/bin/sh

if [ -z "$1" ]; then 
  echo "ERROR: Recipient required."; 
  echo "USAGE: gpg_enc.sh user@domain.com doc.txt"
else 
  if [ -z "$2" ]; then 
    echo "ERROR: file to enc is required."; 
    echo "USAGE: gpg_enc.sh user@domain.com doc.txt"


  else
    /usr/local/bin/gpg -ea --recipient $1 $2
    cat $2.asc |pbcopy


  fi
  

fi
