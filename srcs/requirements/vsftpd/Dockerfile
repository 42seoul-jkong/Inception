# syntax=docker/dockerfile:1

FROM alpine:latest

ARG CERTS_SUBJECT
ARG VSFTPD_PASV_PORT_MIN
ARG VSFTPD_PASV_PORT_MAX

RUN apk add --no-cache \
	vsftpd \
	openssl

COPY selfsign.sh /
COPY configure.sh /
COPY entrypoint.sh /
RUN chmod +x /selfsign.sh /configure.sh /entrypoint.sh && /selfsign.sh && /configure.sh

ENTRYPOINT /entrypoint.sh

STOPSIGNAL SIGKILL
