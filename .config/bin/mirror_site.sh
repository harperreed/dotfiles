#!/bin/bash

#this will mirror a website, upload to s3, and make it publically available. 
#install s3cmd. install wget. (i use homebrew). 
#configure s3cmd (s3cmd --configure)

# run this by doing: mirror_site.sh www.example.org
 
wget --mirror -p --html-extension --convert-links -e robots=off -P . $1
s3cmd mb  s3://$1
s3cmd put --acl-public --recursive $1/  s3://$1
