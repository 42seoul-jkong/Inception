# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache \
	php \
	php-fpm \
	php-json \
	php-mysqli \
	php-curl \
	php-dom \
	php-exif \
	php-fileinfo \
	# php-hash \
	php-mbstring \
	php-openssl \
	# php-pcre \
	php-xml \
	php-zip \
	php-opcache \
	php-gd \
	php-iconv \
	php-intl \
	php8-pecl-imagick \
	php8-redis \
	# php-phar For wp CLI
	php-phar \
	# php-tokenizer For wp config set
	php-tokenizer \
	# php-ftp For Background update
	php-ftp \
	mariadb-client

RUN sed -i "s|.*listen\s*=.*|listen = 9000|g" /etc/php8/php-fpm.d/www.conf

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod 755 /usr/local/bin/wp

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh
