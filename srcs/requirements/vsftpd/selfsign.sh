#!/bin/sh

SSL_TYPE=rsa
SSL_BITS=2048
SSL_DAYS=365
SSL_KEYOUT=/etc/vsftpd/sslcert/key.pem
SSL_OUT=/etc/vsftpd/sslcert/certificate.pem
SSL_SUBJECT=$CERTS_SUBJECT

mkdir -p /etc/vsftpd/sslcert

openssl req -newkey $SSL_TYPE:$SSL_BITS -nodes -keyout $SSL_KEYOUT -x509 -days $SSL_DAYS -out $SSL_OUT -subj $SSL_SUBJECT
