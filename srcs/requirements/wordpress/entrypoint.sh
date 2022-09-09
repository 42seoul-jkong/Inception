#!/bin/sh

sudo_wp() {
	su somebody -c "wp $*"
}

WORDPRESS_PATH_OPTION=--path=/var/www
CACHE_PLUGIN_NAME=redis-cache

adduser -D -h /var/www -u 2000 somebody

sudo_wp core is-installed $WORDPRESS_PATH_OPTION
if [ $? -eq 0 ]
then
	# Update WordPress
	sudo_wp core update $WORDPRESS_PATH_OPTION
	sudo_wp core update-db $WORDPRESS_PATH_OPTION
else
	# Install WordPress
	sudo_wp core download --locale=ko_KR $WORDPRESS_PATH_OPTION
	sudo_wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --locale=ko_KR --extra-php $WORDPRESS_PATH_OPTION << PHP
define( 'FS_METHOD', 'ftpext' );
define( 'FTP_HOST', '$WORDPRESS_FTP_HOST' );
define( 'FTP_USER', '$WORDPRESS_FTP_USER' );
define( 'FTP_PASS', '$WORDPRESS_FTP_PASS' );
define( 'FTP_SSL', true );
PHP
	sudo_wp core install --url=https://$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL $WORDPRESS_PATH_OPTION
	sudo_wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --user_pass=$WORDPRESS_PASSWORD $WORDPRESS_PATH_OPTION
	sudo_wp theme delete --all $WORDPRESS_PATH_OPTION
	sudo_wp plugin delete $(sudo_wp plugin list --status=inactive --field=name $WORDPRESS_PATH_OPTION) $WORDPRESS_PATH_OPTION
fi

# Redis cache plug-in
sudo_wp plugin is-installed $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION
if [ $? -eq 0 ]
then
	# Update plugin
	sudo_wp plugin update $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION
else
	# Install plugin
	sudo_wp plugin install $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION
fi
sudo_wp plugin is-active $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION
if [ $? -ne 0 ]
then
	# Activate plugin
	sudo_wp plugin activate $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION
	sudo_wp plugin auto-updates enable $CACHE_PLUGIN_NAME $WORDPRESS_PATH_OPTION

	# Plugin specific configuration
	sudo_wp config set "WP_REDIS_HOST" "$CACHE_HOST" $WORDPRESS_PATH_OPTION
	sudo_wp config set "WP_REDIS_PORT" 6379 --raw $WORDPRESS_PATH_OPTION
	# sudo_wp config set "WP_REDIS_PASSWORD" "secret" $WORDPRESS_PATH_OPTION
	sudo_wp config set "WP_REDIS_TIMEOUT" 1 --raw $WORDPRESS_PATH_OPTION
	sudo_wp config set "WP_REDIS_READ_TIMEOUT" 1 --raw $WORDPRESS_PATH_OPTION
	sudo_wp config set "WP_REDIS_DATABASE" 0 --raw $WORDPRESS_PATH_OPTION
	sudo_wp redis enable $WORDPRESS_PATH_OPTION
fi

exec php-fpm8 --nodaemonize
