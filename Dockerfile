FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    nginx \
    zip \
    unzip \
    curl \
    libxml2-dev \
    oniguruma-dev \
    libpng-dev \
    libzip \
    libzip-dev \
    openldap-dev \
    supervisor \
    && docker-php-ext-configure zip \
    && docker-php-ext-install \
        mbstring \
        pdo \
        pdo_mysql \
        xml \
        zip \
        ldap \
        gd \
        bcmath \
        exif \
    && rm -rf /var/cache/apk/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
