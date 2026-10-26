FROM php:8.3-cli-alpine

RUN apk add --no-cache icu-libs \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev \
    && apk add --no-cache git unzip curl \
    && docker-php-ext-install pdo_mysql intl \
    && apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader --no-interaction \
    && mkdir -p storage/framework/cache \
       storage/framework/sessions \
       storage/framework/views \
       bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 10000

CMD ["sh", "-c", "php artisan config:clear && php artisan route:clear && php artisan serve --host=0.0.0.0 --port=${PORT:-10000}"]