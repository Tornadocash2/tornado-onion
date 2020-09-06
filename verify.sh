#!/bin/bash
set -e

# PKI Verification 
#gpg: Signature made Sun Sep  6 07:13:54 2020 PDT
#gpg:                using RSA key C00B2090F23C5629029111CBF5D2A7216C51FB94
#gpg: Good signature from "sam bacha <sam@freighttrust.com>" [ultimate]
#gpg:                 aka "Freight Trust Corp <sam@freighttrust.com>" [ultimate]
#
curl -L --progress-bar https://raw.githubusercontent.com/freight-trust/pki/master/6F6EB43E.asc --output 6F6EB43E.asc 
gpg --import 6F6EB43E.asc
openssl dgst -sha256 tornado_onion_SHA256SUMS | cut -d" " -f 2 >> SHA256_OPENSSL
gpg --verify tornado_onion_SHA256SUMS.sig tornado_onion_SHA256SUMS

export SHA256_FROM_FILE=tornado_onion_SHA256SUMS
export SHA256_FROM_OPENSSL=SHA256_OPENSSL

echo "SHA256_FROM_FILE = $SHA256_FROM_FILE"
echo "SHA256_FROM_OPENSSL = $SHA256_FROM_OPENSSL"
 
if [ "$SHA256_FROM_FILE" = "$SHA256_FROM_OPENSSL" ]
    then echo "SHA256 HASH MATCHES. PROCEED!"
else echo "SHA256 HASH DOES NOT MATCH. DO NOT CONTINUE!"
fi

