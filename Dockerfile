FROM php:8.2-cli

# 全域設定
WORKDIR /source
COPY . .

#安裝環境、安裝工具
#安裝 composer 指令
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN apt update && apt install unzip && apt clean && rm -rf /var/lib/apt/lists/*

# 安裝 bcmath 與 redis
RUN docker-php-ext-install bcmath
RUN pecl install redis
RUN docker-php-ext-enable redis

RUN composer install --no-scripts && composer clear-cache


CMD ["php", "artisan", "serve", "--host", "0.0.0.0"]