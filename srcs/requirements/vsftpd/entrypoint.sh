#!/bin/sh

adduser -D -h /var/www $VSFTPD_USER $VSFTPD_USER
chown -R $VSFTPD_USER:$VSFTPD_USER /var/www
echo $VSFTPD_USER:$VSFTPD_PASS | chpasswd

vsftpd /etc/vsftpd/vsftpd.conf
