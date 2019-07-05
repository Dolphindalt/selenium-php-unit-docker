FROM php:5-jessie

MAINTAINER Dalton Caron <dcaron@mtech.edu>

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update -yqq

RUN apt-get install -yqq git \
libmcrypt-dev libpq-dev libcurl4-gnutls-dev \
libicu-dev libvpx-dev libjpeg-dev \
libpng-dev libxpm-dev zlib1g-dev \
libfreetype6-dev libxml2-dev libexpat1-dev \
libbz2-dev libgmp3-dev libldap2-dev \
unixodbc-dev libsqlite3-dev libaspell-dev \
libsnmp-dev libpcre3-dev libtidy-dev mysql-client \
python-pip libasound2 libnspr4 libnss3 libxss1 \
xdg-utils unzip libappindicator1 fonts-liberation

# Install chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chrome driver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -o /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

RUN docker-php-ext-install mbstring mcrypt \
curl json  gd xml zip \
bz2 opcache pdo_mysql
#RUN curl -sS https://getcomposer.org/installer | php && php composer.phar install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN pecl install xdebug-2.5.5
RUN docker-php-ext-enable xdebug

EXPOSE 80 443

