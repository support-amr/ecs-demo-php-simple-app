#!/usr/bin/env bash

cp /var/www/html/.env.example /var/www/html/.env
php /var/www/html/artisan key:generate --ansi

php-fpm &
#crond -L /proc/1/fd/1 -b -l 8 -c /etc/cron.d &
nginx -g "daemon off;"
