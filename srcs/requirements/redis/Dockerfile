# syntax=docker/dockerfile:1

FROM alpine:latest

RUN apk add --no-cache redis

ENTRYPOINT redis-server --protected-mode no
