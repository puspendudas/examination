# Use the official PHP image as base
FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    curl \
    supervisor

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy Laravel files
COPY . .

# Install dependencies
RUN composer install

# Run Laravel migration and seed
RUN php artisan migrate:fresh --seed

# Expose port
EXPOSE 9000

RUN chmod -R 777 storage bootstrap/cache
# Run Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]