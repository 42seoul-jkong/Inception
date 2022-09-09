# syntax=docker/dockerfile:1

FROM alpine:latest

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
