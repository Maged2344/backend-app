# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel application files
COPY . .

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
    
# Enable .htaccess overrides for Apache (in case mod_rewrite is enabled)
RUN echo '<Directory /var/www/html>' > /etc/apache2/conf-available/laravel.conf \
    && echo '    AllowOverride All' >> /etc/apache2/conf-available/laravel.conf \
    && echo '</Directory>' >> /etc/apache2/conf-available/laravel.conf \
    && a2enconf laravel

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 80
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
