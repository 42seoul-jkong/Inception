# syntax=docker/dockerfile:1

FROM alpine:3.15.6

ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD

RUN apk add --no-cache \
	mariadb \
	mariadb-client

COPY install.sh /
COPY healthcheck.sh /
RUN chmod +x /install.sh /healthcheck.sh && /install.sh

ENTRYPOINT mysqld --user=mysql --datadir=/var/lib/mysql

HEALTHCHECK --interval=1s --timeout=1s --start-period=1s --retries=10 \
	CMD [ "/healthcheck.sh" ]
