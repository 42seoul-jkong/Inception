# syntax=docker/dockerfile:1

FROM alpine:3.15.6

RUN apk add --no-cache redis

ENTRYPOINT redis-server --protected-mode no
