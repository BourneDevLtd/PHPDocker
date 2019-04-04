FROM php:7.3.2-apache

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install tools & libraries
RUN apt-get -y install apt-utils nano wget dialog \
    build-essential git curl libcurl3 libcurl3-dev zip

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl3 libcurl3-dev zip \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 mysql-client zlib1g-dev \
    libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev python-pip

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Drush
#RUN composer global require drush/drush
#ENV PATH="{$HOME}/.composer/vendor/bin:${PATH}"
#RUN drush --version
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
  chmod +x drush.phar && \
  mv drush.phar /usr/local/bin/drush
RUN drush --drush-launcher-version

# Python package installer
RUN pip --version

# AWS CLI tools
## EBS
RUN pip install awsebcli --upgrade --user
RUN eb --version

# PHP Extensions
RUN pecl install apcu \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli 

# Enable apache modules
RUN a2enmod rewrite headers

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
