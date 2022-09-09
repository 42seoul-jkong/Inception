#!/bin/sh

adduser -D -h /var/www -u 2000 $VSFTPD_USER $VSFTPD_USER
echo $VSFTPD_USER:$VSFTPD_PASS | chpasswd
chown -R 2000:2000 /var/www

vsftpd /etc/vsftpd/vsftpd.conf
