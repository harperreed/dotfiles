#!/bin/bash

if [ "$1" == "" ]; then
  echo Usage: $0 pngfile
  exit 0
fi

FILE=`basename $1 .png`

if [ ! -e $FILE.png ]; then
  echo $FILE.png does not exist
  exit 1
fi

convert $FILE.png $FILE.pnm
potrace -s -o $FILE.svg $FILE.pnm
rm $FILE.pnm
