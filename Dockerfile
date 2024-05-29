FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libpq-dev \
    libcurl4-gnutls-dev \
    nginx \
    libonig-dev \
    zlib1g-dev \
    libicu-dev \
    libjpeg-dev

# Install Redis extension //pecl = PHP Extension Community Library
RUN pecl install redis && docker-php-ext-enable redis

# Install excimer.so
RUN pecl install excimer && docker-php-ext-enable excimer

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-install mysqli pdo pdo_mysql bcmath curl mbstring zip intl gd

# Enable Process Control support
RUN docker-php-ext-configure pcntl && \
    docker-php-ext-install pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#install Supervisor. -y: The option to automatically assume "yes" to all prompts and run non-interactively.
RUN apt-get update && apt-get install -y supervisor

# Install FFmpeg
RUN apt-get update && apt-get install -y ffmpeg

# Set working directory
WORKDIR /var/www

#This is for branch-1