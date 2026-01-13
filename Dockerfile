# Base image PHP + Apache
FROM php:8.1-apache

# Installa dipendenze di sistema
RUN apt-get update && apt-get install -y \
    libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git cron wget

# Estensioni PHP necessarie
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_pgsql zip

# Configurazione Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Cartella di lavoro
WORKDIR /var/www/html

# Clona ILIAS dal repository ufficiale (release_10)
RUN git clone --depth 1 --single-branch -b release_10 https://github.com/ILIAS-eLearning/ILIAS.git temp_ilias \
    && mv temp_ilias/* temp_ilias/.* . 2>/dev/null \
    && rm -rf temp_ilias

# Permessi corretti
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Porta
EXPOSE 80
