FROM php:8.2-cli-slim
RUN apt-get update && apt-get install -y git unzip
WORKDIR /app
COPY . /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install
