#!/bin/sh
# ABOUTME: Downloads the SSL certificate from a given domain.
# ABOUTME: Saves the certificate text to a .cer.txt file.

DOMAIN="$1"
echo "HEAD / HTTP/1.0\n Host: ${DOMAIN}:443\n\n EOT\n" | openssl s_client -prexit -connect "${DOMAIN}:443" > "${DOMAIN}.cer.txt"
