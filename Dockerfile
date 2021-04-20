FROM php:7.3-fpm

USER root

RUN echo 'alias ll="ls -lah"' >> /root/.bashrc

# Install dependencies
RUN apt-get update \
	# gd
	&& apt-get install -y --no-install-recommends build-essential  openssl nginx libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev gcc g++ make vim unzip curl git jpegoptim optipng pngquant gifsicle locales libonig-dev nodejs npm  \
	&& docker-php-ext-configure gd  \
	&& docker-php-ext-install gd \
	# gmp
	&& apt-get install -y --no-install-recommends libgmp-dev \
	&& docker-php-ext-install gmp \
	# pdo_mysql
	&& docker-php-ext-install pdo_mysql mbstring \
	# pdo
	&& docker-php-ext-install pdo \
	# opcache
	&& docker-php-ext-enable opcache \
	# zip
	&& docker-php-ext-install zip \
	&& apt-get autoclean -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/pear/

COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer \
	&& composer self-update --1

WORKDIR /var/www/html

# Remove default nginx file
RUN rm *.html

ADD ./src /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN composer install && composer dump-autoload

#COPY ./.docker/nginx/post_deploy.sh /usr/local/bin/post_deploy.sh
#RUN ["chmod", "+x", "/usr/local/bin/post_deploy.sh"]
#CMD [ "sh", "/usr/local/bin/post_deploy.sh" ]

EXPOSE 80

# Start nginx
STOPSIGNAL SIGTERM

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]