## 更改Laravel首頁，並轉變成自己的image
#### 事前準備
一開始，先把 Laravel 主程式先準備好。參考 Installing Laravel 文件，安裝 PHP 與 Composer，然後執行下面指令即可把 Laravel 程式安裝至 blog 目錄。

#### 安裝composer
```
#step 1 更新系統檔案
sudo apt-get update

#step 2 安裝curl和PHP
sudo apt-get install curl

#step 3 安裝php
sudo apt-get install php php-curl

#step4 透過crul 下載composer
curl -sS https://getcomposer.org/installer -o composer-setup.php

#step5 安裝composer
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

#### 把Laravel 程式安裝至 `blog` 目錄
`composer create-project --prefer-dist laravel/laravel blog`

#### 撰寫Dockerfile
```
FROM php:8.2-cli

# 全域設定
WORKDIR /source


#安裝環境、安裝工具
#安裝 composer 指令
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN apt update && apt install unzip && apt clean && rm -rf /var/lib/apt/lists/*

# 安裝 bcmath 與 redis
RUN docker-php-ext-install bcmath
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN composer install --no-scripts && composer clear-cache

#複製程式碼
COPY . .


CMD ["php", "artisan", "serve", "--host", "0.0.0.0"]
```

說明：
container裡的預設的路徑是根目錄 `/`，是個一不小心就會刪錯檔案的位置，可以換到一個比較安全的目錄，比方說 `/source`：
`WORKDIR /source #此段加入在Dockerfile裡`

`WORKDIR` 可以設定預設工作目錄。它同時是 `docker build` 過程與 `docker run` 的工作目錄，跟 -w 選項的意義相同。

接著把 Laravel 原始碼複製進 container 裡，這裡使用 `COPY` 指令：
※是指將本地建立的laravel log資料夾檔案複製到container的資料夾
`COPY . . #此段加入在Dockerfile裡`

#### 透過bind mount將本地資料夾空間與container綁在一起
`docker -v '/blog/resources':/source/resources #將虛擬機的資料夾綁定container的資料夾`

`docker run -d -it -v 'pwd':/source/resources -p 8000:8000 6c77288161a6 `

#### 將本地改的檔案透過 FileZilla 傳入 vm, vm檔案連動container 檔案

#### 透過 docker commit 將 container build 成 image


