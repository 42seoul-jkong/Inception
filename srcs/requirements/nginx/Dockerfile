# syntax=docker/dockerfile:1

FROM alpine:3.15.6

ARG DOMAIN_NAME
ARG CERTS_SUBJECT
ARG NGINX_FCGI_HOST

RUN apk add --no-cache \
	nginx \
	openssl

COPY selfsign.sh /
COPY configure.sh /
RUN chmod +x /selfsign.sh /configure.sh && /selfsign.sh && /configure.sh

ENTRYPOINT nginx -g "daemon off;"
