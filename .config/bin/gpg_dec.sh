#!/bin/sh
# ABOUTME: Decrypts a GPG-encrypted file and writes the plaintext to a .txt file.
# ABOUTME: Usage: gpg_dec.sh doc.txt.asc

if [ -z "$1" ]; then
  echo "ERROR: File to dec required.";
  echo "USAGE: gpg_dec.sh doc.txt.asc"
else
  gpg -d "$1" > "$1.txt"
fi
