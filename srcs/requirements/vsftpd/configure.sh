#!/bin/sh

sed -i "s|.*anonymous_enable\s*=.*|anonymous_enable=NO|g" /etc/vsftpd/vsftpd.conf
sed -i "s|.*local_enable\s*=.*|local_enable=YES|g" /etc/vsftpd/vsftpd.conf
sed -i "s|.*write_enable\s*=.*|write_enable=YES|g" /etc/vsftpd/vsftpd.conf
sed -i "s|.*chroot_local_user\s*=.*|chroot_local_user=YES|g" /etc/vsftpd/vsftpd.conf

cat >> /etc/vsftpd/vsftpd.conf << EOF
seccomp_sandbox=NO
allow_writeable_chroot=YES

listen_port=21

port_enable=YES
ftp_data_port=20

pasv_enable=YES
pasv_min_port=$VSFTPD_PASV_PORT_MIN
pasv_max_port=$VSFTPD_PASV_PORT_MAX

ssl_enable=YES

# To allow anonymous users to use SSL
allow_anon_ssl=NO

# To force anonymous users to use SSL
force_anon_data_ssl=NO
force_anon_logins_ssl=NO

# To force local users to use SSL
force_local_data_ssl=YES
force_local_logins_ssl=YES

# Permit TLS v1.2+ protocol connections. TLS v1.2+ connections are preferred
# ssl_tlsv1_3=YES
# ssl_tlsv1_2=YES
# ssl_tlsv1_1=NO
# ssl_tlsv1=NO

# Permit TLS v1 protocol connections. TLS v1 connections are preferred
ssl_tlsv1=YES
ssl_sslv3=NO
ssl_sslv2=NO

rsa_cert_file=/etc/vsftpd/sslcert/certificate.pem
rsa_private_key_file=/etc/vsftpd/sslcert/key.pem

require_ssl_reuse=NO
ssl_ciphers=HIGH
EOF
