#!/bin/bash

SCREENSHOT_DIR=~/Dropbox/Public/screenshots
FILENAME="screenshot_$(date '+%Y-%m-%d_%N').png"

scrot $SCREENSHOT_DIR/$FILENAME
echo "http://dl.dropbox.com/u/45107/screenshots/$FILENAME" |xclip
echo "http://dl.dropbox.com/u/45107/screenshots/$FILENAME"
