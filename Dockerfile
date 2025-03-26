FROM php:8.2-fpm-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    zip \
    unzip \
    curl \
    libxml2-dev \
    libonig-dev \
    libpng-dev \
    libzip4 \
    libzip-dev \
    libldap2-dev \
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
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        libxml2-dev \
        libonig-dev \
        libpng-dev \
        libzip-dev \
        libldap2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
