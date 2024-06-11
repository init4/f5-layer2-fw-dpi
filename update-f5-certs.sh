#!/bin/bash
#
export datestring=`date '+%d%m%y'`

# Copy certs from CA host 
#
umask 077
ssh admin@rootca.local 'sudo -S cat /etc/letsencrypt/live/test.org/privkey.pem' > /tmp/privkey.pem 
ssh admin@rootca.local 'sudo -S cat /etc/letsencrypt/live/test.org/fullchain.pem' > /tmp/fullchain.pem 

# Figure out sizes of files to be uploaded 
#
size_p=`stat -f %z /tmp/privkey.pem`
size_p_r=$((size_p-1))
size_c=`stat -f %z /tmp/fullchain.pem`
size_c_r=$((size_c-1))
#echo "size_p $size_p size_p_r $size_p_r size_c $size_c size_c_r $size_c_r "

# Install certs in a new crypto profile
#
curl -o /dev/null -sku admin:changeme https://10.0.0.250/mgmt/shared/file-transfer/uploads/test-wildcard-$datestring.key -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$size_p_r/$size_p" -H 'Connection: Close' --data-binary @/tmp/privkey.pem 
curl -o /dev/null -sku admin:changeme https://10.0.0.250/mgmt/shared/file-transfer/uploads/test-wildcard-$datestring.crt -H 'Content-Type: application/octet-stream' -H "Content-Range: 0-$size_c_r/$size_c" -H 'Connection: Close' --data-binary @/tmp/fullchain.pem 
echo "{\"command\":\"install\",\"name\":\"test-wildcard-$datestring\",\"from-local-file\":\"/var/config/rest/downloads/test-wildcard-$datestring.key\"}" > /tmp/privkey.json 
curl -o /dev/null -sku admin:changeme https://10.0.0.250/mgmt/tm/sys/crypto/key -H 'Content-Type: application/json' -d @/tmp/privkey.json 
echo "{\"command\":\"install\",\"name\":\"test-wildcard-$datestring\",\"from-local-file\":\"/var/config/rest/downloads/test-wildcard-$datestring.crt\"}" > /tmp/fullchain.json 
curl -o /dev/null -sku admin:changeme https://10.0.0.250/mgmt/tm/sys/crypto/cert -H 'Content-Type: application/json' -d @/tmp/fullchain.json

# Clean up
#
rm -f /tmp/privkey*
rm -f /tmp/fullchain*
 
