#!/bin/sh
# lowerit
# convert all file names in the current directory to lower case
# only operates on plain files--does not change the name of directories
# will ask for verification before overwriting an existing file
for x in `ls`
  do
  if [ ! -f $x ]; then
    continue
    fi
  lc=`echo $x  | tr '[A-Z]' '[a-z]'`
  if [ $lc != $x ]; then
    mv -i $x $lc
    fi
  done
