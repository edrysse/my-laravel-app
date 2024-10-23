# Use the official PHP image with Apache
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    zip \
    vim \
    unzip \
    git \
    curl

# Enable Apache modules and PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy the application files to the container
COPY . /var/www/html

# Set the Apache document root to Laravel's public directory
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Disable directory listing
RUN echo "Options -Indexes" >> /etc/apache2/apache2.conf

# Ensure proper permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Create SQLite database file
RUN touch /var/www/html/database/database.sqlite

# Expose the port Apache is running on
EXPOSE 80
