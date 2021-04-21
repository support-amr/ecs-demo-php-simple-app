#!/usr/bin/env bash
## ------------------------
## Setup Laravel for first time
## ------------------------
#cp /var/www/html/.env.example /var/www/html/.env
#php /var/www/html/artisan key:generate --ansi

## ------------------------
## PREPARE APP ENVIRONMENT
## ------------------------
# Prepare .env file from passed environment variable
echo -e ${env_dump_without_spaces//;/\\n} > .env
php artisan config:cache
php artisan cache:clear

## ------------------------
## Your script
## ------------------------


## ------------------------
## START NGINX
## ------------------------
php-fpm &
#crond -L /proc/1/fd/1 -b -l 8 -c /etc/cron.d &
nginx -g "daemon off;"
