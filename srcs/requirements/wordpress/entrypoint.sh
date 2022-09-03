#!/bin/sh

WORDPRESS_PATH_OPTION=--path=/var/www

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
	wp core install --url=$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL $WORDPRESS_PATH_OPTION
	wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD $WORDPRESS_PATH_OPTION
fi

exec php-fpm8 --nodaemonize
