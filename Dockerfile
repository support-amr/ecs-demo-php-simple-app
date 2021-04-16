FROM php:7.3-apache

# SET Environment Variables
#ENV APP_DOMAIN ${APP_DOMAIN}

RUN apt-get update && apt-get install -y \
        unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libaio1 \
        libldap2-dev \
        vim \
        nano \
        libzip-dev \
        zip \
    && docker-php-ext-install -j$(nproc) iconv gettext \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql mysqli bcmath \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install zip

# Install XDebug - Required for code coverage in PHPUnit
#RUN yes | pecl install xdebug \
#    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
#
## Copy over the php conf
#COPY ./.docker/php/docker-php.conf /etc/apache2/conf-enabled/docker-php.conf
#
## COPY VHOST file
COPY ./.docker/apache/default.conf /etc/apache2/sites-available/000-default.conf
#
## Copy over the php ini
#COPY ./.docker/php/docker-php.ini $PHP_INI_DIR/conf.d/

# Set the timezone
#ENV TZ=${TIMEZONE}
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN printf "log_errors = On \nerror_log = /dev/stderr\n" > /usr/local/etc/php/conf.d/php-logs.ini

# Enable mod_rewrite
RUN a2enmod rewrite

RUN echo 'umask 002' >> /root/.bashrc
# Copy bash scripts and enable
RUN echo 'alias ll="ls -lah"' >> /root/.bashrc

# Install Composer
#ENV COMPOSER_HOME /composer
#ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
#ENV COMPOSER_ALLOW_SUPERUSER 1
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN composer --version

#ENV APACHE_LOG_DIR /var/log/apache2

# Add the files and set permissions
WORKDIR /var/www/html
ADD ./src /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Might still need to do this inside the Dockerfile to get the Laravel cache cleaned and loaded
# RUN php artisan config:clear && php artisan config:cache

EXPOSE 80
