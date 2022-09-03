# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache \
			nginx \
			openssl

RUN openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem -subj "/"

ENTRYPOINT nginx -g "daemon off;"
