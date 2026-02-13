#!/bin/sh
# ABOUTME: Converts all filenames in the current directory to lowercase.
# ABOUTME: Only operates on plain files, asks before overwriting existing files.

for x in *; do
  if [ ! -f "$x" ]; then
    continue
  fi
  lc=$(echo "$x" | tr '[A-Z]' '[a-z]')
  if [ "$lc" != "$x" ]; then
    mv -i "$x" "$lc"
  fi
done
