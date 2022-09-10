# syntax=docker/dockerfile:1

FROM alpine:3.15.6

RUN apk add --no-cache \
	php8 \
	php8-fpm \
	php8-json \
	php8-mysqli \
	php8-curl \
	php8-dom \
	php8-exif \
	php8-fileinfo \
	# php8-hash \
	php8-mbstring \
	php8-openssl \
	# php8-pcre \
	php8-xml \
	php8-zip \
	php8-opcache \
	php8-gd \
	php8-iconv \
	php8-intl \
	php8-pecl-imagick \
	php8-redis \
	# php8-phar For wp CLI
	php8-phar \
	# php8-tokenizer For wp config set
	php8-tokenizer \
	# php8-ftp For Background update
	php8-ftp \
	# php8-ctype For Redis plug-in
	php8-ctype \
	mariadb-client

RUN ln -s /usr/bin/php8 /usr/bin/php
RUN sed -i "s|.*listen\s*=.*|listen = 9000|g" /etc/php8/php-fpm.d/www.conf

RUN mkdir -p /var/adminer/
ADD https://www.adminer.org/latest-mysql.php /var/adminer/adminer.php
RUN chmod 755 /var/adminer/adminer.php

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod 755 /usr/local/bin/wp

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh

HEALTHCHECK --interval=1s --timeout=1s --start-period=1s --retries=120 \
	CMD [ "nc", "-z", "localhost", "9000" ]
