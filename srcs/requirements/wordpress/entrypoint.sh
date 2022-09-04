#!/bin/sh

PHP_FPM_DAEMON_USER=nobody
PHP_FPM_DAEMON_GROUP=nobody
WORDPRESS_PATH=/var/www
WORDPRESS_PATH_OPTION=--path=$WORDPRESS_PATH

wp core is-installed $WORDPRESS_PATH_OPTION
if [ $? -eq 0 ]
then
	# Update WordPress
	wp core update $WORDPRESS_PATH_OPTION
	wp core update-db $WORDPRESS_PATH_OPTION
else
	# Install WordPress
	wp core download --locale=ko_KR $WORDPRESS_PATH_OPTION
	wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --locale=ko_KR $WORDPRESS_PATH_OPTION
	wp core install --url=https://$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL $WORDPRESS_PATH_OPTION
	wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD $WORDPRESS_PATH_OPTION
	wp theme delete --all $WORDPRESS_PATH_OPTION
	wp plugin delete $(wp plugin list --status=inactive --field=name $WORDPRESS_PATH_OPTION) $WORDPRESS_PATH_OPTION
fi

# Enable FTP
wp config delete FS_METHOD $WORDPRESS_PATH_OPTION
wp config set FTP_USER wordpress $WORDPRESS_PATH_OPTION
wp config set FTP_PASS wordpress $WORDPRESS_PATH_OPTION
wp config set FTP_HOST host_ftp $WORDPRESS_PATH_OPTION

# Disable FTP (temporary)
wp config set FS_METHOD direct $WORDPRESS_PATH_OPTION
chown -R $PHP_FPM_DAEMON_USER:$PHP_FPM_DAEMON_GROUP $WORDPRESS_PATH

exec php-fpm8 --nodaemonize
