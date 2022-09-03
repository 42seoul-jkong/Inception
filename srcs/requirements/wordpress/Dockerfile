# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache \
			php \
			php-phar \
			php-fpm \
			php-json \
			php-mysqli \
			php-curl \
			php-dom \
			php-exif \
			php-fileinfo \
			# php-hash \
			# php-imagick \
			php-mbstring \
			php-openssl \
			# php-pcre \
			php-xml \
			php-zip \
			# php-memcached \
			php-opcache \
			# php-redis \
			mariadb-client

RUN sed -i "s|.*listen\s*=.*|listen = 9000|g" /etc/php8/php-fpm.d/www.conf

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
COPY entrypoint.sh /
RUN chmod +x /usr/local/bin/wp /entrypoint.sh

ENTRYPOINT /entrypoint.sh
