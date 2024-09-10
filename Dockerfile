FROM php:8.3.10-fpm-alpine

# Install system dependencies and PHP extensions
RUN apk update && apk add --no-cache \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring

# Set the working directory
WORKDIR /var/www/github1-app

# Copy the composer files and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-dev --optimize-autoloader

# Copy the entire Laravel project to the container
COPY . .

# Expose port 8000 and run the Laravel development server
EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000
