FROM php:8.1-apache

# Installa dipendenze
RUN apt-get update && apt-get install -y \
    libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git cron wget

# PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_pgsql zip

# Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

WORKDIR /var/www/html

# Clona tutto il repo ufficiale release_10 in cartella ilias
RUN git clone --depth 1 --single-branch -b release_10 https://github.com/ILIAS-eLearning/ILIAS.git ilias

# Permessi
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Creiamo un index.php nella root per redirect automatico
RUN echo "<?php header('Location: /ilias/setup/setup.php'); exit;" > /var/www/html/index.php

EXPOSE 80
