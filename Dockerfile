FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git cron wget

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_pgsql zip

COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

WORKDIR /var/www/html

# Clona release_10 (repo pubblico)
RUN git clone --depth 1 --single-branch -b release_10 https://github.com/ILIAS-eLearning/ILIAS.git temp_ilias \
    && cp -r temp_ilias/. . \
    && rm -rf temp_ilias

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
