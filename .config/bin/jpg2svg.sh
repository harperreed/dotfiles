#!/bin/bash

if [ "$1" == "" ]; then
  echo Usage: $0 jpgfile
  exit 0
fi

FILE=`basename $1 .jpg`

if [ ! -e $FILE.jpg ]; then
  echo $FILE.jpg does not exist
  exit 1
fi

convert $FILE.jpg $FILE.pnm
potrace -s -o $FILE.svg $FILE.pnm
rm $FILE.pnm
