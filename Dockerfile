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

# Clona release_10 del repo ufficiale
RUN git clone --depth 1 --single-branch -b release_10 https://github.com/ILIAS-eLearning/ILIAS.git temp_ilias \
    && cp -r temp_ilias/Customizing temp_ilias/Modules temp_ilias/Services temp_ilias/setup temp_ilias/index.php temp_ilias/lang temp_ilias/templates . \
    && rm -rf temp_ilias

# Permessi
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
