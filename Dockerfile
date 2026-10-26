FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-dev icu-libs \
    && docker-php-ext-install pdo_mysql intl \
    && apk del icu-dev
