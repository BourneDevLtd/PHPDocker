FROM php:7.3.5-apache
LABEL maintainer="Robert Bourne (BourneDevLtd) <robertbourne86+github@gmail.com>"

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install tools & libraries
RUN apt-get -y install --fix-missing apt-utils nano wget dialog \
    build-essential git curl libcurl3 libcurl3-dev zip libzip-dev \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 mysql-client zlib1g-dev \
    libicu-dev libfreetype6-dev libjpeg62-turbo-dev python-pip libpng-dev 

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Drush
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
  chmod +x drush.phar && \
  mv drush.phar /usr/local/bin/drush
RUN drush --drush-launcher-version

# Python package installer
RUN pip --version

# AWS CLI tools
RUN pip install --upgrade awsebcli awscli

RUN mkdir ~/.aws

#RUN eb --version

# PHP Extensions
RUN pecl install apcu \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip

# XDebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Enable apache modules
RUN a2enmod rewrite headers

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
