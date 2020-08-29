#!/bin/sh
#

MARKDOWN_FILE=$1
FILENAME=$(echo $MARKDOWN_FILE | cut -f 1 -d '.')

if [ -f "$MARKDOWN_FILE" ];
then

  pandoc -S "${MARKDOWN_FILE}" -o "${MARKDOWN_FILE}.epub"
  /Applications/calibre.app/Contents/MacOS/ebook-convert "${MARKDOWN_FILE}.epub"  "${FILENAME}.mobi"
  rm "${MARKDOWN_FILE}.epub"
fi


