# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache gitea

COPY --chown=gitea:www-data gitea_config.ini /etc/gitea/app.ini

ENTRYPOINT su gitea -c gitea
