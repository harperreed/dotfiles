
DOMAIN=$1
echo "HEAD / HTTP/1.0\n Host: $DOMAIN:443\n\n EOT\n" | openssl s_client -prexit -connect $DOMAIN:443 > $DOMAIN.cer.txt
