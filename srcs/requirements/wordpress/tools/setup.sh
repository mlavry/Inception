#!/bin/bash
set -eu


echo "⏳ Waiting for MariaDB..."

while ! mariadb-admin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent
do
	sleep 2
done

echo "✅ MariaDB is ready!"


mkdir -p /var/www/html
cd /var/www/html


if [ ! -f wp-config.php ]; then

	echo "⬇️ Downloading WordPress..."
	wp core download --allow-root

	echo "Creating wp-config.php..."
	wp config create \
		--allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOST"

	echo "Installing WordPress..."
	wp core install \
		--allow-root \
		--url="$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"
	
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--allow-root
fi

sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' \
/etc/php/8.2/fpm/pool.d/www.conf

mkdir -p /run/php

echo "🎯 Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F
