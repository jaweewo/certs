#!/bin/bash

#
# Usage:
# ./certs.sh file
# 
# The required input to make_certs.sh is the path to your pfx file without the .pfx prefix
# 
# file.key
# file.crt (includes ca-certs)
#

filename=$1

# extracting ca-certs
echo "> Extracting ca-certs..."
openssl pkcs12 -in ${filename}.pfx -nodes -nokeys -cacerts -out ${filename}-ca.crt
echo "done!"
echo " "

# extracting key
echo "> Extracting key file..."
openssl pkcs12 -in ${filename}.pfx -nocerts -out ${filename}.key
echo "done!"
echo " "

# extracting crt
echo "> Extracting crt..."
openssl pkcs12 -in ${filename}.pfx -clcerts -nokeys -out ${filename}.crt

echo "> Combining ca-certs with crt file..."
# combine ca-certs and cert files
cat ${filename}-ca.crt ${filename}.crt > ${filename}-full.crt

# remove passphrase from key file
echo "> Removing passphrase from keyfile"

openssl rsa -in ${filename}.key -out ${filename}.key

# clean up
rm ${filename}-ca.crt
mv ${filename}-full.crt ${filename}.crt

echo "done!"
echo " "
echo "Extraction complete! 🐼"
echo "created files:"
echo " 🔑  ${filename}.key"
echo " 📄  ${filename}.crt"
