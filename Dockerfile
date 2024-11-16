# BUILD STAGE: Install Composer Dependencies
FROM composer:2.4 AS build
COPY . /app/
WORKDIR /app
RUN composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

# PRODUCTION STAGE: PHP 8.2 with Apache
FROM php:8.2-apache AS production

# Set Environment Variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install Dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql pdo_pgsql \
    && docker-php-ext-enable opcache \
    && rm -rf /var/lib/apt/lists/*

# Configure Apache
COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Copy Application Code and Set Permissions
COPY --from=build /app /var/www/html
COPY .env.example /var/www/html/.env
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html

# Cache Configuration and Optimize Laravel
WORKDIR /var/www/html


# Expose Application Port
EXPOSE 80

# Start Apache Server
CMD ["apache2-foreground"]

