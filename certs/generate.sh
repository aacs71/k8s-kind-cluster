#!/bin/bash

# Geração os certificados para o cluster e seguir as regras com os SAN correctos
# Isto porque o nginx não gosta muito de não os ter.... :- 

openssl genrsa -out k8s-ca-key.pem 4096
openssl req -x509 -new -nodes -key k8s-ca-key.pem -sha256 -days 1826 -out k8s-ca-crt.pem -subj '/CN=ca.my.k8s/C=PT/ST=Braga/L=Famalicao/O=Casa/OU=Escritorio'

ALL_DOMAINS=(dashboard grafana prometheus alertmanager)

for DOMAIN in ${ALL_DOMAINS[@]}; do

    openssl genrsa -out $DOMAIN-key.pem 4096
    openssl req -new -key $DOMAIN-key.pem -out $DOMAIN.csr -subj "/CN=$DOMAIN.my.k8s/C=PT/ST=Braga/L=Famalicao/O=Casa"

cat > tmp.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
DNS.2 = $DOMAIN.my.k8s
IP.1 = 127.0.0.1
EOF

    openssl x509 -req -in $DOMAIN.csr -CA k8s-ca-crt.pem -CAkey k8s-ca-key.pem -CAcreateserial -out $DOMAIN-crt.pem -days 825 -sha256 -subj "/CN=$DOMAIN.my.k8s/C=PT/ST=Braga/L=Famalicao/O=Casa/OU=Escritorio" -extfile tmp.ext 
done
rm -rf tmp.ext
rm -rf *.csr

# instalar no sistema
sudo cp k8s-ca-crt.pem /usr/local/share/ca-certificates/k8s-ca-crt.crt
sudo update-ca-certificates