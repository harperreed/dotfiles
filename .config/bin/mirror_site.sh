#!/bin/bash
# ABOUTME: Mirrors a website using wget and uploads it to an S3 bucket.
# ABOUTME: Usage: mirror_site.sh www.example.org

#install s3cmd. install wget. (i use homebrew).
#configure s3cmd (s3cmd --configure)

wget --mirror -p --html-extension --convert-links -e robots=off -P . "$1"
s3cmd mb "s3://$1"
s3cmd put --acl-public --recursive "$1/" "s3://$1"
